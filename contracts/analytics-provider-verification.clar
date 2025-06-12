;; Analytics Provider Verification Contract
;; Validates and manages performance analytics providers

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_PROVIDER_NOT_FOUND (err u101))
(define-constant ERR_PROVIDER_ALREADY_EXISTS (err u102))
(define-constant ERR_INVALID_REPUTATION (err u103))

;; Provider data structure
(define-map providers
  { provider-id: uint }
  {
    address: principal,
    name: (string-ascii 50),
    reputation-score: uint,
    is-verified: bool,
    registration-block: uint
  }
)

(define-data-var next-provider-id uint u1)

;; Register a new analytics provider
(define-public (register-provider (name (string-ascii 50)))
  (let ((provider-id (var-get next-provider-id)))
    (asserts! (is-none (map-get? providers { provider-id: provider-id })) ERR_PROVIDER_ALREADY_EXISTS)
    (map-set providers
      { provider-id: provider-id }
      {
        address: tx-sender,
        name: name,
        reputation-score: u50,
        is-verified: false,
        registration-block: block-height
      }
    )
    (var-set next-provider-id (+ provider-id u1))
    (ok provider-id)
  )
)

;; Verify a provider (only contract owner)
(define-public (verify-provider (provider-id uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (match (map-get? providers { provider-id: provider-id })
      provider-data
      (begin
        (map-set providers
          { provider-id: provider-id }
          (merge provider-data { is-verified: true })
        )
        (ok true)
      )
      ERR_PROVIDER_NOT_FOUND
    )
  )
)

;; Update provider reputation
(define-public (update-reputation (provider-id uint) (new-score uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (asserts! (<= new-score u100) ERR_INVALID_REPUTATION)
    (match (map-get? providers { provider-id: provider-id })
      provider-data
      (begin
        (map-set providers
          { provider-id: provider-id }
          (merge provider-data { reputation-score: new-score })
        )
        (ok true)
      )
      ERR_PROVIDER_NOT_FOUND
    )
  )
)

;; Get provider information
(define-read-only (get-provider (provider-id uint))
  (map-get? providers { provider-id: provider-id })
)

;; Check if provider is verified
(define-read-only (is-provider-verified (provider-id uint))
  (match (map-get? providers { provider-id: provider-id })
    provider-data (get is-verified provider-data)
    false
  )
)
