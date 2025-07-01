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

# IP Information

```swift
IPINFO.shared.getDetails(ip: "39.53.87.37") { status, data, msg in
    switch status {
        case .success:
            print(data)
        case .failure:
            print(msg)
    }
}
```

# ASN

```swift
IPINFO.shared.getASNDetails(asn: "AS13335") { status, data, msg in
    switch status {
        case .success:
            print(data)
        case .failure:
            print(msg)
    }
}
```

# Bulk

```swift
let ipAddresses = ["AS123", "8.8.8.8", "9.9.9.9/hostname", "2001:0:c000:200::0:255:1", "0.0.0.0"]

IPINFO.shared.getBatch(ipAddresses: ipAddresses, withFilter: false) { status, response, msg in
    switch response {
        case .success:
             guard let response else { return }
            if let ansResponse = response["AS123"] as? ASNResponse{
                print(ansResponse)
            }
            if let ipResponse = response["8.8.8.8"] as? IPResponse{
                print(ipResponse)
            }
            if let ipHostname = response["9.9.9.9/hostname"] as? String{
                 print(ipHostname)
            }
            if let batchIPV4 = response["0.0.0.0"] as? IPResponse{
                print(batchIPV4)
            }
            if let batchIPV6 = response["2001:0:c000:200::0:255:1"] as? IPResponse{
                print(batchIPV6)
            }
        case .failure:
            print(msg)
    }
}
```

# Country Name Lookup

This library provides a system to lookup country names through ISO2 country codes.
```swift
IPINFO.shared.getDetails(ip: "8.8.8.8") { status, response, msg in
    guard let response else {return}
    switch status {
        case .success:
            guard let response else { return }
            // Print out the country code
            print(response.country)
            // Print out the country name
            print(response.countryName)
            
        case .failure:
            print(msg)
    }
}
```

# EU Country Lookup

This library provides a system to lookup if a country is a member of the European Union (EU) through ISO2 country codes.
```swift
IPINFO.shared.getDetails(ip: "8.8.8.8") { status, response, msg in
    guard let response else {return}
    switch status {
        case .success:
            // Print out whether the country is a member of the EU
            print(response.isEU ?? false)
        case .failure:
            print(msg)
    }
}
```

# Internationalization

This library provides a system to lookup if a country is a member of the European Union (EU), emoji and unicode of the country's flag, code and symbol of the country's currency, and public link to the country's flag image as an SVG and continent code and name through ISO2 country codes.

```swift
IPINFO.shared.getDetails(ip: "8.8.8.8") { status, response, msg in
    guard let response else {return}
    switch status {
        case .success:
            // Print out whether the country is a member of the EU
            print(response.isEU ?? false)
            // CountryFlag{emoji='🇺🇸',unicode='U+1F1FA U+1F1F8'}
            print(response.getCountryFlag ?? CountryFlag(emoji: "🇺🇸", unicode: "U+1F1FA U+1F1F8"))
            // https://cdn.ipinfo.io/static/images/countries-flags/US.svg
            print(response.getCountryFlagURL ?? "https://cdn.ipinfo.io/static/images/countries-flags/US.svg")
            // CountryCurrency{code='USD',symbol='$'}
            print(response.getCountryCurrency?.code ?? "USD")
            print(response.getCountryCurrency?.symbol ?? "$")
            // Continent{code='NA',name='North America'}
            print(response.getContinent?.code ?? "NA")
            print(response.getContinent?.name ?? "North America")
        case .failure:
            print(msg)
    }
}
```

# Location Information

This library provides an easy way to get the latitude and longitude of an IP Address:

```swift
IPINFO.shared.getDetails(ip: "8.8.8.8") { status, response, msg in
    guard let response else {return}
    switch status {
        case .success:
            // Print out the Latitude and Longitude
            print(response.getLatitude ?? "")
            print(response.getLongitude ?? "")
         case .failure:
            print(msg)
    }
}
```

# Contributing

## Running the tests

Some tests require a [token](https://ipinfo.io/dashboard/token) to pass. You can add yours as an [environment variable of the scheme](https://developer.apple.com/documentation/xcode/customizing-the-build-schemes-for-a-project/#Specify-launch-arguments-and-environment-variables).  

# Other Libraries

There are official [IPinfo client libraries](https://ipinfo.io/developers/libraries) available for many languages including PHP, Python, Go, Java, Ruby, and many popular frameworks such as Django, Rails, and Laravel. There are also many third-party libraries and integrations available for our API.

# About IPinfo

Founded in 2013, IPinfo prides itself on being the most reliable, accurate, and in-depth source of IP address data available anywhere. We process terabytes of data to produce our custom IP geolocation, company, carrier, VPN detection, hosted domains, and IP type data sets. Our API handles over 40 billion requests a month for 100,000 businesses and developers.

[![image](https://avatars3.githubusercontent.com/u/15721521?s=128&u=7bb7dde5c4991335fb234e68a30971944abc6bf3&v=4)](https://ipinfo.io/)
