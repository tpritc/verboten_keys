# Changelog

## 1.2.0 - June 22, 2025

* **New**: Added `:raise` strategy option. When set, Verboten Keys will raise a `VerbotenKeys::ForbiddenKeyError` if a forbidden key is found in the response body.
* **Removed**: I've removed support for Ruby 2.7, 3.0, and 3.1. The new minimum supported Ruby version is 3.2.0.

## 1.1.1 - October 24, 2022

* **Fixed**: Updated the `nokogiri` dependency to protect against [CVE-2022-2309](https://nvd.nist.gov/vuln/detail/CVE-2022-2309), [CVE-2022-40304](https://nvd.nist.gov/vuln/detail/CVE-2022-40304), [CVE-2022-40303](https://nvd.nist.gov/vuln/detail/CVE-2022-40303), and [CVE-2022-37434](https://ubuntu.com/security/CVE-2022-37434).

## 1.1.0 - October 16, 2022

* **New**: Support for Ruby version 3.1.
* **Removed**: I've removed support for Ruby 2.5 and 2.6. The new minimum supported Ruby version is 2.7.
* **Fixed**: Updated dependencies to protect against CVEs.

## 1.0.1 - August 28, 2021

* **Fixed**: Update the `railties` dependency to protect against [CVE-2021-22942](https://discuss.rubyonrails.org/t/cve-2021-22942-possible-open-redirect-in-host-authorization-middleware/78722).

## 1.0.0 - May 11, 2021

* Initial release
