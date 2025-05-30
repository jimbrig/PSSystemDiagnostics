# Unified System Software Report - Table Format
*Generated on: {{report_date}}*
*System: {{system_name}}*

## Executive Summary

| Metric | Value |
|--------|-------|
| **Total Programs** | {{total_programs}} |
| **Total Storage** | {{total_storage}} |
| **Report Generation Tool** | {{tool_name}} |
| **Analysis Date** | {{report_date}} |

## Category Overview

| Category | Program Count | Storage Used | Percentage | Report Time |
|----------|---------------|--------------|------------|-------------|
{{#category_summary}}
| {{category}} | {{count}} | {{size}} | {{percentage}} | {{generated_date}} |
{{/category_summary}}

---

## Standard Applications Inventory

### Development Environment

| Application Name | Category | Size | Installation Status |
|------------------|----------|------|-------------------|
{{#development.languages}}
| {{name}} | Programming Language | {{size}} | Active |
{{/development.languages}}
{{#development.tools}}
| {{name}} | Development Tool | {{size}} | Active |
{{/development.tools}}
{{#development.vcs}}
| {{name}} | Version Control | {{size}} | Active |
{{/development.vcs}}

### Cloud & Infrastructure

| Service/Tool | Type | Size | Purpose |
|--------------|------|------|---------|
{{#cloud.platforms}}
| {{name}} | Cloud Platform | {{size}} | Platform Integration |
{{/cloud.platforms}}
{{#cloud.infrastructure}}
| {{name}} | Infrastructure Tool | {{size}} | DevOps |
{{/cloud.infrastructure}}

### Productivity Suite

| Application | Suite | Size | License Type |
|-------------|-------|------|--------------|
{{#productivity.office}}
| {{name}} | Microsoft Office | {{size}} | Commercial |
{{/productivity.office}}
{{#productivity.frameworks}}
| {{name}} | Development Framework | {{size}} | Enterprise |
{{/productivity.frameworks}}

### Data Analysis Tools

| Tool Name | Category | Size | Primary Use |
|-----------|----------|------|-------------|
{{#data.r_ecosystem}}
| {{name}} | R Ecosystem | {{size}} | Statistical Analysis |
{{/data.r_ecosystem}}
{{#data.documentation}}
| {{name}} | Documentation | {{size}} | Content Creation |
{{/data.documentation}}

### System Utilities

| Utility Name | Function | Size | Criticality |
|--------------|----------|------|-------------|
{{#utilities.file_management}}
| {{name}} | File Management | {{size}} | High |
{{/utilities.file_management}}
{{#utilities.optimization}}
| {{name}} | System Optimization | {{size}} | Medium |
{{/utilities.optimization}}

---

## Hidden Programs Analysis

| Program Name | Type | Size | Visibility Reason |
|--------------|------|------|-------------------|
{{#hidden.framework_updates}}
| {{name}} | Framework Update | {{#size}}{{size}}{{/size}}{{^size}}N/A{{/size}} | System Component |
{{/hidden.framework_updates}}
{{#hidden.dev_tools}}
| {{name}} | Development Tool | {{size}} | Background Service |
{{/hidden.dev_tools}}
{{#hidden.system_services}}
| {{name}} | System Service | {{#size}}{{size}}{{/size}}{{^size}}N/A{{/size}} | Core Windows |
{{/hidden.system_services}}

---

## Store Applications Catalog

### Microsoft Ecosystem

| Application | Category | Size | Store Type |
|-------------|----------|------|------------|
{{#store.microsoft_core}}
| {{name}} | Core Windows | {{size}} | Microsoft Store |
{{/store.microsoft_core}}
{{#store.microsoft_productivity}}
| {{name}} | Productivity | {{size}} | Microsoft Store |
{{/store.microsoft_productivity}}

### Development & System Tools

| Tool Name | Purpose | Size | Source |
|-----------|---------|------|--------|
{{#store.sysinternals}}
| {{name}} | System Analysis | {{size}} | Microsoft Store |
{{/store.sysinternals}}
{{#store.dev_environments}}
| {{name}} | Development | {{size}} | Microsoft Store |
{{/store.dev_environments}}

### Entertainment & Media

| Application | Media Type | Size | Subscription |
|-------------|------------|------|--------------|
{{#store.entertainment}}
| {{name}} | Streaming/Media | {{size}} | Various |
{{/store.entertainment}}
{{#store.gaming}}
| {{name}} | Gaming | {{size}} | Xbox/Gaming |
{{/store.gaming}}

---

## System Components Matrix

### .NET Framework Ecosystem

| Component Name | Version Type | Size | Architecture |
|----------------|--------------|------|--------------|
{{#system.dotnet_runtimes}}
| {{name}} | Runtime | {{#size}}{{size}}{{/size}}{{^size}}N/A{{/size}} | Multi-platform |
{{/system.dotnet_runtimes}}
{{#system.dotnet_sdks}}
| {{name}} | SDK | {{#size}}{{size}}{{/size}}{{^size}}N/A{{/size}} | Development |
{{/system.dotnet_sdks}}

### Visual C++ Redistributables

| Package Name | Architecture | Size | Compatibility |
|--------------|--------------|------|---------------|
{{#system.vcpp_redistributables}}
| {{name}} | Mixed | {{#size}}{{size}}{{/size}}{{^size}}N/A{{/size}} | Legacy Support |
{{/system.vcpp_redistributables}}

### Windows SDK Components

| SDK Component | Purpose | Size | Target Platform |
|---------------|---------|------|-----------------|
{{#system.windows_sdk}}
| {{name}} | Development | {{#size}}{{size}}{{/size}}{{^size}}N/A{{/size}} | Windows |
{{/system.windows_sdk}}
{{#system.sdk_headers}}
| {{name}} | Headers/Libraries | {{#size}}{{size}}{{/size}}{{^size}}N/A{{/size}} | Multi-arch |
{{/system.sdk_headers}}

### Database & Language Components

| Component | Technology | Size | Runtime Type |
|-----------|------------|------|--------------|
{{#system.sql_components}}
| {{name}} | SQL Server | {{#size}}{{size}}{{/size}}{{^size}}N/A{{/size}} | Database |
{{/system.sql_components}}
{{#system.python_components}}
| {{name}} | Python | {{size}} | Interpreter |
{{/system.python_components}}

---

## Storage Analysis Dashboard

### Top Storage Consumers

| Rank | Application | Size | Category | Optimization Potential |
|------|-------------|------|----------|----------------------|
{{#top_storage_consumers}}
| {{rank}} | {{name}} | {{size}} | {{category}} | {{optimization_level}} |
{{/top_storage_consumers}}

### Storage Distribution by Category

| Category | Programs | Total Size | Average Size | Percentage of Total |
|----------|----------|------------|--------------|-------------------|
{{#storage_distribution}}
| {{category}} | {{programs}} | {{storage}} | {{average_size}} | {{percentage}} |
{{/storage_distribution}}

---

## Risk Assessment Matrix

### Security & Compliance

| Application | Risk Level | Last Updated | Compliance Status | Action Required |
|-------------|------------|--------------|-------------------|-----------------|
{{#security_assessment}}
| {{name}} | {{risk_level}} | {{last_updated}} | {{compliance}} | {{action}} |
{{/security_assessment}}

### Performance Impact Analysis

| Resource Type | High Impact Apps | Medium Impact Apps | Low Impact Apps | Total Impact |
|---------------|------------------|-------------------|-----------------|--------------|
{{#performance_impact}}
| {{resource}} | {{high_count}} | {{medium_count}} | {{low_count}} | {{total_impact}} |
{{/performance_impact}}

---

## Recommendations Dashboard

### Immediate Actions Required

| Priority | Action Item | Estimated Savings | Complexity | Timeline |
|----------|-------------|-------------------|------------|----------|
{{#recommendations.immediate}}
| {{priority}} | {{title}} | {{estimated_savings}} | {{complexity}} | {{timeline}} |
{{/recommendations.immediate}}

### Maintenance Schedule

| Task | Frequency | Next Due | Automation Possible | Owner |
|------|-----------|----------|-------------------|-------|
{{#recommendations.maintenance}}
| {{task}} | {{frequency}} | {{next_due}} | {{automation}} | {{owner}} |
{{/recommendations.maintenance}}

### Capacity Planning Metrics

| Metric | Current Value | Projected 6mo | Projected 1yr | Threshold Alert |
|--------|---------------|---------------|---------------|-----------------|
{{#capacity_metrics}}
| {{metric}} | {{current}} | {{projected_6mo}} | {{projected_1yr}} | {{threshold}} |
{{/capacity_metrics}}

---

## System Health Score

| Component | Score | Status | Trend | Last Check |
|-----------|-------|--------|-------|------------|
| **Overall System** | {{health.overall_score}}/100 | {{health.overall_status}} | {{health.overall_trend}} | {{report_date}} |
| **Storage Health** | {{health.storage_score}}/100 | {{health.storage_status}} | {{health.storage_trend}} | {{report_date}} |
| **Security Posture** | {{health.security_score}}/100 | {{health.security_status}} | {{health.security_trend}} | {{report_date}} |
| **Performance** | {{health.performance_score}}/100 | {{health.performance_status}} | {{health.performance_trend}} | {{report_date}} |
