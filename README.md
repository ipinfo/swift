
# [<img src="https://ipinfo.io/static/ipinfo-small.svg" alt="IPinfo" width="24"/>](https://ipinfo.io/) Official Swift client library for IPinfo API (IP geolocation and other types of IP data)

This is the official Swift client library for the [IPinfo.io](https://ipinfo.io) IP address API, allowing you to look up your own IP address, or get any of the following details for other IP addresses:

- [IP to Geolocation](https://ipinfo.io/ip-geolocation-api) (city, region, country, postal code, latitude, and longitude)
- [IP to ASN](https://ipinfo.io/asn-api) (ISP or network operator, associated domain name, and types such as business, hosting, or company)
- [Batch](https://ipinfo.io/developers/advanced-usage#batching-requests) (Our /batch API endpoint allows you to group up to 1000 IPinfo API requests into a single request. This can really speed up the processing of bulk IP lookups, and it can also be useful if you want to look up information across our different APIs.)

# Getting Started
You'll need an IPinfo API access token, which you can get by signing up for a free account at [https://ipinfo.io/signup](https://ipinfo.io/signup).

The free plan is limited to 50,000 requests per month, and doesn't include some of the data fields such as IP type and company data. To enable all the data fields and additional request volumes see [https://ipinfo.io/pricing](https://ipinfo.io/pricing)


## Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. 

Once you have your Swift package set up, adding ipinfo as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/ipinfo/swift", .upToNextMajor(from: "0.1.0"))
]
```
# Authentication
The IPinfo Swift library can be authenticated with your IPinfo API access token, which is passed with this key `IPInfoKitAccessToken` in `info.plist` file. Your IPinfo access token can be found in the account section of IPinfo's website after you have signed in: https://ipinfo.io/account/token

# Geolocation
```swift
IPINFO.shared.getDetails(ip: "39.53.87.37") { status, data, msg in
    switch status {
        case .success:
            print(data)
        case .failure:
            fatalError(msg)
    }
}
```
# ASN
```swift
IPINFO.shared.getASNDetails(asn: "AS13335") { status, data, msg in
    switch status {
        case .success:
            print(JSON(data))
        case .failure:
            fatalError(msg)
    }
}
```
# Bulk
```swift
let ipAddresses = ["8.8.8.8", "8.8.4.4", "208.67.222.222", "208.67.220.220"]

IPINFO.shared.getBatch(ipAddresses: ipAddresses, withFilter: false) { response, data, msg in
    switch response {
        case .success:
            print(JSON(data))
        case .failure:
            fatalError(msg)
    }
}
```

# Other Libraries

There are official [IPinfo client libraries](https://ipinfo.io/developers/libraries) available for many languages including PHP, Python, Go, Java, Ruby, and many popular frameworks such as Django, Rails, and Laravel. There are also many third-party libraries and integrations available for our API.

# About IPinfo

Founded in 2013, IPinfo prides itself on being the most reliable, accurate, and in-depth source of IP address data available anywhere. We process terabytes of data to produce our custom IP geolocation, company, carrier, VPN detection, hosted domains, and IP type data sets. Our API handles over 40 billion requests a month for 100,000 businesses and developers.

[![image](https://avatars3.githubusercontent.com/u/15721521?s=128&u=7bb7dde5c4991335fb234e68a30971944abc6bf3&v=4)](https://ipinfo.io/)
