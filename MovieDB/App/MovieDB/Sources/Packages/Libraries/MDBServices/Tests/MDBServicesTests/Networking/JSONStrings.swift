//
//  JSONStrings.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

let countries2JSON = """
{
  "status": "ok",
  "data": [
    {
      "id": 0,
      "name": "Ukraine",
      "alpha2": "UA",
      "country_code": "380",
      "flag": "http://storage/public/img/flags/ua.png"
    },
    {
      "id": 1,
      "name": "Test",
      "alpha2": "T",
      "country_code": "111",
      "flag": "http://storage/public/img/flags/ua.png"
    }
  ]
}
"""

let countries2FailableJSON = """
{
  "status": "oks",
  "data": [
    {
      "id": 0,
      "name": "Ukraine",
      "alpha2": "UA",
      "country_code": "380",
      "flag": "http://storage/public/img/flags/ua.png"
    },
    {
      "id": null,
      "name": "Test",
      "alpha2": "T",
      "country_code": "111",
      "flag": null
    }
  ]
}
"""
