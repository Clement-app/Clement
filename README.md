# Clement iOS app (Active Development)

Clement is an adblocking SwiftUI app for Safari on iOS utilising content-blocking Safari extensions.

- Supports the most common Adblock-style rule lists out of the box with the ability to toggle lists on and off.
- Includes the ability to add new Adblock-style rule lists given their URLs.
- Includes the ability to add exceptions for certain websites.
- Uses [Brave's Rust-based adblock engine](https://github.com/brave/adblock-rust) compiled for iOS using UniFFI under the hood.
- Updates daily through a silent push notification, running on JS Cloudflare Workers.
