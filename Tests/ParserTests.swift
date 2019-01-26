//
//  ParserTests.swift
//  SemverTests
//
//  Created by Nate Kim on 21/01/2019.
//  Copyright © 2019 glwithu06. All rights reserved.
//

import Foundation
import XCTest
import Semver

class ParserTests: XCTestCase {

    func testParseBasicVersion() throws {
        let ver = try Semver.parse("1.452.368")

        XCTAssertEqual(ver.major, "1")
        XCTAssertEqual(ver.minor, "452")
        XCTAssertEqual(ver.patch, "368")
        XCTAssertEqual(ver.prereleaseIdentifiers, [])
        XCTAssertEqual(ver.buildMetadataIdentifiers, [])
    }

    func testParsePrereleaseVersion() throws {
        let ver = try Semver.parse("1.452.368-rc.alpha.11.log-test")

        XCTAssertEqual(ver.major, "1")
        XCTAssertEqual(ver.minor, "452")
        XCTAssertEqual(ver.patch, "368")
        XCTAssertEqual(ver.prereleaseIdentifiers.count, 4)
        XCTAssertEqual(ver.prereleaseIdentifiers[0], "rc")
        XCTAssertEqual(ver.prereleaseIdentifiers[1], "alpha")
        XCTAssertEqual(ver.prereleaseIdentifiers[2], "11")
        XCTAssertEqual(ver.prereleaseIdentifiers[3], "log-test")
        XCTAssertEqual(ver.buildMetadataIdentifiers, [])
    }

    func testParseBuildMetadataVersion() throws {
        let ver = try Semver.parse("1.452.368+sha.exp.5114f85.20190121")

        XCTAssertEqual(ver.major, "1")
        XCTAssertEqual(ver.minor, "452")
        XCTAssertEqual(ver.patch, "368")
        XCTAssertEqual(ver.prereleaseIdentifiers, [])
        XCTAssertEqual(ver.buildMetadataIdentifiers.count, 4)
        XCTAssertEqual(ver.buildMetadataIdentifiers[0], "sha")
        XCTAssertEqual(ver.buildMetadataIdentifiers[1], "exp")
        XCTAssertEqual(ver.buildMetadataIdentifiers[2], "5114f85")
        XCTAssertEqual(ver.buildMetadataIdentifiers[3], "20190121")
    }

    func testParseBigNumberVersion() throws {
        let ver = try Semver.parse("69938113471411635120691317071569414.64537206108257636612034178144141277.47527207420859796686256474452275428")
        XCTAssertEqual(ver.major, "69938113471411635120691317071569414")
        XCTAssertEqual(ver.minor, "64537206108257636612034178144141277")
        XCTAssertEqual(ver.patch, "47527207420859796686256474452275428")
    }

    func testParseFullVersion() throws {
        let ver = try Semver.parse("69938113471411635120691317071569414.452.368-rc.alpha.11.log-test+sha.exp.5114f85.20190121")

        XCTAssertEqual(ver.major, "69938113471411635120691317071569414")
        XCTAssertEqual(ver.minor, "452")
        XCTAssertEqual(ver.patch, "368")
        XCTAssertEqual(ver.prereleaseIdentifiers.count, 4)
        XCTAssertEqual(ver.prereleaseIdentifiers[0], "rc")
        XCTAssertEqual(ver.prereleaseIdentifiers[1], "alpha")
        XCTAssertEqual(ver.prereleaseIdentifiers[2], "11")
        XCTAssertEqual(ver.prereleaseIdentifiers[3], "log-test")
        XCTAssertEqual(ver.buildMetadataIdentifiers.count, 4)
        XCTAssertEqual(ver.buildMetadataIdentifiers[0], "sha")
        XCTAssertEqual(ver.buildMetadataIdentifiers[1], "exp")
        XCTAssertEqual(ver.buildMetadataIdentifiers[2], "5114f85")
        XCTAssertEqual(ver.buildMetadataIdentifiers[3], "20190121")
    }

    func testParsePrefixedVersion() throws {
        let ver = try Semver.parse("v001.452.368-rc.alpha.11.log-test")

        XCTAssertEqual(ver.major, "001")
        XCTAssertEqual(ver.minor, "452")
        XCTAssertEqual(ver.patch, "368")
        XCTAssertEqual(ver.prereleaseIdentifiers.count, 4)
        XCTAssertEqual(ver.prereleaseIdentifiers[0], "rc")
        XCTAssertEqual(ver.prereleaseIdentifiers[1], "alpha")
        XCTAssertEqual(ver.prereleaseIdentifiers[2], "11")
        XCTAssertEqual(ver.prereleaseIdentifiers[3], "log-test")
        XCTAssertEqual(ver.buildMetadataIdentifiers, [])
    }

    func testParseMajorOnlyVersion() throws {
        let ver = try Semver.parse("v1-rc.alpha.11.log-test")

        XCTAssertEqual(ver.major, "1")
        XCTAssertEqual(ver.minor, "0")
        XCTAssertEqual(ver.patch, "0")
        XCTAssertEqual(ver.prereleaseIdentifiers.count, 4)
        XCTAssertEqual(ver.prereleaseIdentifiers[0], "rc")
        XCTAssertEqual(ver.prereleaseIdentifiers[1], "alpha")
        XCTAssertEqual(ver.prereleaseIdentifiers[2], "11")
        XCTAssertEqual(ver.prereleaseIdentifiers[3], "log-test")
        XCTAssertEqual(ver.buildMetadataIdentifiers, [])
    }

    func testParseMajorMinorVersion() throws {
        let ver = try Semver.parse("v1.354-rc.alpha.11.log-test")

        XCTAssertEqual(ver.major, "1")
        XCTAssertEqual(ver.minor, "354")
        XCTAssertEqual(ver.patch, "0")
        XCTAssertEqual(ver.prereleaseIdentifiers.count, 4)
        XCTAssertEqual(ver.prereleaseIdentifiers[0], "rc")
        XCTAssertEqual(ver.prereleaseIdentifiers[1], "alpha")
        XCTAssertEqual(ver.prereleaseIdentifiers[2], "11")
        XCTAssertEqual(ver.prereleaseIdentifiers[3], "log-test")
        XCTAssertEqual(ver.buildMetadataIdentifiers, [])
    }

    func testParseInvalidVersion() {
        let invalidVersions = [
            "",
            "lorem ipsum",
            "0.a.0-pre+meta",
            "0.0.b-pre+meta",
            "0.0.0- +meta",
            "0.0.0-+meta",
            "0.0.0-+",
            "0.0.0-_+meta",
            "0.0.0-pre+_",
            "0.-100.3"
        ]
        for version in invalidVersions {
            XCTAssertThrowsError(try Semver.parse(version))
        }
    }

    func testParseIntVersion() throws {
        let ver = try Semver(version: 1)

        XCTAssertEqual(ver.major, "1")
        XCTAssertEqual(ver.minor, "0")
        XCTAssertEqual(ver.patch, "0")
        XCTAssertEqual(ver.prereleaseIdentifiers, [])
        XCTAssertEqual(ver.buildMetadataIdentifiers, [])
    }

    func testParseNegativeIntVersion() throws {
        XCTAssertThrowsError(try Semver(version: -11))
    }

    func testParseFloatVersion() throws {
        let ver = try Semver(version: 1.5637881234)

        XCTAssertEqual(ver.major, "1")
        XCTAssertEqual(ver.minor, "5637881234")
        XCTAssertEqual(ver.patch, "0")
        XCTAssertEqual(ver.prereleaseIdentifiers, [])
        XCTAssertEqual(ver.buildMetadataIdentifiers, [])
    }

    func testParseStringVersion() throws {
        let ver = try Semver(version: "v001.452.368-rc.alpha.11.log-test")

        XCTAssertEqual(ver.major, "001")
        XCTAssertEqual(ver.minor, "452")
        XCTAssertEqual(ver.patch, "368")
        XCTAssertEqual(ver.prereleaseIdentifiers.count, 4)
        XCTAssertEqual(ver.prereleaseIdentifiers[0], "rc")
        XCTAssertEqual(ver.prereleaseIdentifiers[1], "alpha")
        XCTAssertEqual(ver.prereleaseIdentifiers[2], "11")
        XCTAssertEqual(ver.prereleaseIdentifiers[3], "log-test")
        XCTAssertEqual(ver.buildMetadataIdentifiers, [])
    }

    func testParseInvalidStringVersion() {
        let invalidVersions = [
            "",
            "lorem ipsum",
            "0.a.0-pre+meta",
            "0.0.b-pre+meta",
            "0.0.0- +meta",
            "0.0.0-+meta",
            "0.0.0-+",
            "0.0.0-_+meta",
            "0.0.0-pre+_",
            "0.-100.3"
        ]
        for version in invalidVersions {
            XCTAssertThrowsError(try Semver(version: version))
        }
    }
}
