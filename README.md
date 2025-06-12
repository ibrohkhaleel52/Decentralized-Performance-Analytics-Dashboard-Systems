# Decentralized Performance Analytics Dashboard System

A comprehensive blockchain-based performance analytics platform built on Stacks using Clarity smart contracts.

## Overview

This system provides a decentralized solution for performance analytics, featuring provider verification, data integration, metric calculations, dashboard management, and alert coordination.

## Architecture

### Core Contracts

1. **Analytics Provider Verification** (`analytics-provider-verification.clar`)
    - Validates and manages performance analytics providers
    - Handles provider registration, verification, and reputation scoring
    - Ensures data quality through provider credibility

2. **Data Integration** (`data-integration.clar`)
    - Integrates multiple performance data sources
    - Manages data source registration and validation
    - Stores and retrieves performance metrics

3. **Metric Calculation** (`metric-calculation.clar`)
    - Performs calculations on raw performance data
    - Supports aggregation functions (average, min, max)
    - Manages calculation rules and computed metrics

4. **Dashboard Management** (`dashboard-management.clar`)
    - Creates and manages performance dashboards
    - Handles widget placement and configuration
    - Manages user access permissions

5. **Alert Coordination** (`alert-coordination.clar`)
    - Coordinates performance alerts and notifications
    - Manages alert rules and thresholds
    - Handles alert subscriptions and notifications

## Features

### Provider Management
- Provider registration and verification
- Reputation scoring system
- Decentralized provider validation

### Data Integration
- Multi-source data integration
- Real-time data submission
- Data source management and validation

### Analytics & Calculations
- Automated metric calculations
- Aggregation rules and functions
- Historical data analysis

### Dashboard System
- Customizable performance dashboards
- Widget-based interface
- Role-based access control

### Alert System
- Configurable alert rules
- Multiple notification methods
- Alert acknowledgment and resolution

## Getting Started

### Prerequisites
- Stacks blockchain node
- Clarity development environment
- Stacks wallet for transactions

### Deployment

1. Deploy contracts in the following order:
   \`\`\`bash
   # Deploy provider verification first
   clarinet deploy analytics-provider-verification.clar

   # Deploy data integration
   clarinet deploy data-integration.clar

   # Deploy metric calculation
   clarinet deploy metric-calculation.clar

   # Deploy dashboard management
   clarinet deploy dashboard-management.clar

   # Deploy alert coordination
   clarinet deploy alert-coordination.clar
   \`\`\`

### Usage Examples

#### Register as Analytics Provider
\`\`\`clarity
(contract-call? .analytics-provider-verification register-provider "MyAnalytics")
\`\`\`

#### Create Data Source
\`\`\`clarity
(contract-call? .data-integration register-data-source u1 "performance" "https://api.example.com/metrics")
\`\`\`

#### Submit Performance Data
\`\`\`clarity
(contract-call? .data-integration submit-data u1 "response-time" u150)
\`\`\`

#### Create Dashboard
\`\`\`clarity
(contract-call? .dashboard-management create-dashboard "My Dashboard" "Performance metrics dashboard" true)
\`\`\`

#### Set Up Alert Rule
\`\`\`clarity
(contract-call? .alert-coordination create-alert-rule "response-time" "gt" u200)
\`\`\`

## Contract Functions

### Analytics Provider Verification
- `register-provider`: Register new analytics provider
- `verify-provider`: Verify provider (owner only)
- `update-reputation`: Update provider reputation score
- `get-provider`: Get provider information
- `is-provider-verified`: Check verification status

### Data Integration
- `register-data-source`: Register new data source
- `submit-data`: Submit performance data
- `get-data-source`: Get data source information
- `get-performance-data`: Retrieve performance data
- `toggle-source-status`: Enable/disable data source

### Metric Calculation
- `create-aggregation-rule`: Create calculation rule
- `calculate-average`: Calculate average of values
- `calculate-maximum`: Find maximum value
- `calculate-minimum`: Find minimum value
- `store-calculated-metric`: Store computed metric
- `get-calculated-metric`: Retrieve calculated metric

### Dashboard Management
- `create-dashboard`: Create new dashboard
- `add-widget`: Add widget to dashboard
- `grant-access`: Grant user access permissions
- `get-dashboard`: Get dashboard information
- `can-view-dashboard`: Check view permissions

### Alert Coordination
- `create-alert-rule`: Create alert rule
- `trigger-alert`: Trigger alert based on conditions
- `subscribe-to-alerts`: Subscribe to alert notifications
- `acknowledge-alert`: Acknowledge alert
- `resolve-alert`: Resolve alert

## Error Codes

### Provider Verification (100-199)
- `100`: Unauthorized access
- `101`: Provider not found
- `102`: Provider already exists
- `103`: Invalid reputation score

### Data Integration (200-299)
- `200`: Unauthorized access
- `201`: Data source not found
- `202`: Invalid data type
- `203`: Data already exists

### Metric Calculation (300-399)
- `300`: Unauthorized access
- `301`: Metric not found
- `302`: Invalid calculation
- `303`: Division by zero

### Dashboard Management (400-499)
- `400`: Unauthorized access
- `401`: Dashboard not found
- `402`: Access denied
- `403`: Invalid configuration

### Alert Coordination (500-599)
- `500`: Unauthorized access
- `501`: Alert not found
- `502`: Invalid threshold
- `503`: Rule not found

## Security Considerations

- All contracts implement proper access controls
- Provider verification ensures data quality
- Permission-based dashboard access
- Secure alert rule management

## Testing

Run the test suite using:
\`\`\`bash
npm test
\`\`\`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License.
