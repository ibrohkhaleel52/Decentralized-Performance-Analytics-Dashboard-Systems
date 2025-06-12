;; Dashboard Management Contract
;; Manages performance dashboards and user access

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u400))
(define-constant ERR_DASHBOARD_NOT_FOUND (err u401))
(define-constant ERR_ACCESS_DENIED (err u402))
(define-constant ERR_INVALID_CONFIG (err u403))

;; Dashboard structure
(define-map dashboards
  { dashboard-id: uint }
  {
    owner: principal,
    name: (string-ascii 50),
    description: (string-ascii 200),
    is-public: bool,
    created-at: uint,
    last-updated: uint
  }
)

;; Dashboard widgets
(define-map dashboard-widgets
  { widget-id: uint }
  {
    dashboard-id: uint,
    widget-type: (string-ascii 20),
    metric-source: uint,
    position-x: uint,
    position-y: uint,
    width: uint,
    height: uint
  }
)

;; Access permissions
(define-map dashboard-permissions
  { dashboard-id: uint, user: principal }
  {
    can-view: bool,
    can-edit: bool,
    granted-at: uint
  }
)

(define-data-var next-dashboard-id uint u1)
(define-data-var next-widget-id uint u1)

;; Create a new dashboard
(define-public (create-dashboard
  (name (string-ascii 50))
  (description (string-ascii 200))
  (is-public bool))
  (let ((dashboard-id (var-get next-dashboard-id)))
    (map-set dashboards
      { dashboard-id: dashboard-id }
      {
        owner: tx-sender,
        name: name,
        description: description,
        is-public: is-public,
        created-at: block-height,
        last-updated: block-height
      }
    )
    (var-set next-dashboard-id (+ dashboard-id u1))
    (ok dashboard-id)
  )
)

;; Add widget to dashboard
(define-public (add-widget
  (dashboard-id uint)
  (widget-type (string-ascii 20))
  (metric-source uint)
  (position-x uint)
  (position-y uint)
  (width uint)
  (height uint))
  (let ((widget-id (var-get next-widget-id)))
    (match (map-get? dashboards { dashboard-id: dashboard-id })
      dashboard-data
      (if (or (is-eq tx-sender (get owner dashboard-data))
              (default-to false (get can-edit (map-get? dashboard-permissions
                { dashboard-id: dashboard-id, user: tx-sender }))))
        (begin
          (map-set dashboard-widgets
            { widget-id: widget-id }
            {
              dashboard-id: dashboard-id,
              widget-type: widget-type,
              metric-source: metric-source,
              position-x: position-x,
              position-y: position-y,
              width: width,
              height: height
            }
          )
          (var-set next-widget-id (+ widget-id u1))
          (ok widget-id)
        )
        ERR_ACCESS_DENIED
      )
      ERR_DASHBOARD_NOT_FOUND
    )
  )
)

;; Grant dashboard access
(define-public (grant-access
  (dashboard-id uint)
  (user principal)
  (can-view bool)
  (can-edit bool))
  (match (map-get? dashboards { dashboard-id: dashboard-id })
    dashboard-data
    (if (is-eq tx-sender (get owner dashboard-data))
      (begin
        (map-set dashboard-permissions
          { dashboard-id: dashboard-id, user: user }
          {
            can-view: can-view,
            can-edit: can-edit,
            granted-at: block-height
          }
        )
        (ok true)
      )
      ERR_UNAUTHORIZED
    )
    ERR_DASHBOARD_NOT_FOUND
  )
)

;; Get dashboard information
(define-read-only (get-dashboard (dashboard-id uint))
  (map-get? dashboards { dashboard-id: dashboard-id })
)

;; Get widget information
(define-read-only (get-widget (widget-id uint))
  (map-get? dashboard-widgets { widget-id: widget-id })
)

;; Check user permissions
(define-read-only (check-permissions (dashboard-id uint) (user principal))
  (map-get? dashboard-permissions { dashboard-id: dashboard-id, user: user })
)

;; Check if user can view dashboard
(define-read-only (can-view-dashboard (dashboard-id uint) (user principal))
  (match (map-get? dashboards { dashboard-id: dashboard-id })
    dashboard-data
    (or (get is-public dashboard-data)
        (is-eq user (get owner dashboard-data))
        (default-to false (get can-view (map-get? dashboard-permissions
          { dashboard-id: dashboard-id, user: user }))))
    false
  )
)
