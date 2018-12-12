//
//  DokuWiki.swift
//  DokuWiki
//
//  Created by Connor Temple on 12/11/18.
//  Copyright © 2018 Connor Temple. All rights reserved.
//

import Foundation
import Cocoa
import SWXMLHash

enum DokuError: Error {
	case DataError
	case ParseError
	case XMLError
	case APIFailure
}

public class DokuWiki {
	
	var session: URLSession
	var xmlRPC: URL
	var auth: String
	
	public init(session: URLSession, xmlRPC: URL, auth: String) {
		self.session = session
		self.xmlRPC = xmlRPC
		self.auth = auth
	}
	
	func exec(requestBody: String, completionHandler: @escaping (_ data: Data?, _ err: Error?) -> Void) {
		var request = URLRequest(url: xmlRPC)
		
		request.httpMethod = "POST"
		request.httpBody = requestBody.data(using: String.Encoding.isoLatin1)
		
		request.addValue(auth, forHTTPHeaderField: "Authorization")
		request.addValue("application/xml", forHTTPHeaderField: "Content-Type")
		request.addValue("application/xml", forHTTPHeaderField: "Accept")
		
		let task = session.dataTask(with: request as URLRequest, completionHandler: { data, resp, err in
			completionHandler(data, err)
		})
		task.resume()
	}
	
	public func getPagelist(namespace:String, depth:Int, completionHandler: @escaping (_ pageList: [String]?, _ err: Error?) -> Void) -> Void {
		let body = """
<?xml version="1.0"?>
<methodCall>
	<methodName>dokuwiki.getPagelist</methodName>
	<params>
		<param>
			<value>
				<string></string>
			</value>
		</param>
		<param>
			<value>
				<struct>
					<member>
						<name>depth</name>
						<value>
							<int>0</int>
						</value>
					</member>
				</struct>
			</value>
		</param>
	</params>
</methodCall>
"""
		exec(requestBody: body, completionHandler: { data, err in
			guard err == nil else { // pass err along if received
				completionHandler(nil, err)
				return
			}
			
			guard let data = data else { // err if data not present
				completionHandler(nil, Optional(DokuError.DataError))
				return
			}
			
			// err if unable to parse | todo: get encoding from header
			guard let stringData = String(data: data, encoding: String.Encoding.isoLatin1) else {
				completionHandler(nil, Optional(DokuError.ParseError))
				return
			}
			
			// err if unable to find element
			let xml = SWXMLHash.parse(stringData)
			//			guard  else {
			//				completionHandler(nil, Optional(DokuError.XMLError))
			//				return
			//			}
			let contents = xml["methodResponse"]["params"]["param"]["value"]["array"]["data"]["value"].all
			
			var list: [String] = [String]()
			for i in contents {
				if let id = i["struct"]["member"][0]["value"]["string"].element {
					list.append(id.text)
				}
			}
			
			// if all goes well data should be returned
			completionHandler(list, nil)
		})
	}
	
	public func getPage(page: String, completionHandler: @escaping (_ raw: String?, _ err: Error?) -> Void) -> Void {
		let body = """
<?xml version="1.0"?>
<methodCall>
	<methodName>wiki.getPage</methodName>
	<params>
		<param>
			<value>
				<string>\(page)</string>
			</value>
		</param>
	</params>
</methodCall>
"""
		
		exec(requestBody: body, completionHandler: { data, err in
			guard err == nil else { // pass err along if received
				completionHandler(nil, err)
				return
			}
			
			guard let data = data else { // err if data not present
				completionHandler(nil, Optional(DokuError.DataError))
				return
			}
			
			// err if unable to parse | todo: get encoding from header
			guard let stringData = String(data: data, encoding: String.Encoding.isoLatin1) else {
				completionHandler(nil, Optional(DokuError.ParseError))
				return
			}
			
			// err if unable to find element
			let xml = SWXMLHash.parse(stringData)
			guard let contents = xml["methodResponse"]["params"]["param"]["value"]["string"].element else {
				completionHandler(nil, Optional(DokuError.XMLError))
				return
			}
			
			// if all goes well data should be returned
			completionHandler(contents.text, nil)
		})
	}
	
	public func getPageHTML(page: String, completionHandler: @escaping (_ html: String?, _ err: Error?) -> Void) -> Void {
		let body = """
<?xml version="1.0"?>
<methodCall>
	<methodName>wiki.getPageHTML</methodName>
	<params>
		<param>
			<value>
				<string>\(page)</string>
			</value>
		</param>
	</params>
</methodCall>
"""
		
		exec(requestBody: body, completionHandler: { data, err in
			guard err == nil else { // pass err along if received
				completionHandler(nil, err)
				return
			}
			
			guard let data = data else { // err if data not present
				completionHandler(nil, Optional(DokuError.DataError))
				return
			}
			
			// err if unable to parse | todo: get encoding from header
			guard let stringData = String(data: data, encoding: String.Encoding.isoLatin1) else {
				completionHandler(nil, Optional(DokuError.ParseError))
				return
			}
			
			// err if unable to find element
			let xml = SWXMLHash.parse(stringData)
			guard let contents = xml["methodResponse"]["params"]["param"]["value"]["string"].element else {
				completionHandler(nil, Optional(DokuError.XMLError))
				return
			}
			
			// if all goes well data should be returned
			completionHandler(contents.text, nil)
		})
	}
	
	public func putPage(page: String, contents: String, summary: String, minor: Bool, completionHandler: @escaping (_ success: Bool?, _ err: Error?) -> Void) -> Void {
		let body = """
<?xml version="1.0"?>
<methodCall>
	<methodName>wiki.putPage</methodName>
		<params>
			<param>
				<value>
					<string>\(page)</string>
				</value>
			</param>
			<param>
				<value>
					<string>\(contents)</string>
				</value>
			</param>
			<param>
				<value>
					<struct>
						<member>
							<name>sum</name>
							<value><string>\(summary)</string></value>
						</member>
						<member>
							<name>minor</name>
							<value><boolean>\(minor ? "True" : "False")</boolean></value>
						</member>
					</struct>
				</value>
			</param>
		</params>
</methodCall>
"""
		
		exec(requestBody: body, completionHandler: { data, err in
			guard err == nil else { // pass err along if received
				completionHandler(nil, err)
				return
			}
			
			guard let data = data else { // err if data not present
				completionHandler(nil, Optional(DokuError.DataError))
				return
			}
			
			// err if unable to parse | todo: get encoding from header
			guard let stringData = String(data: data, encoding: String.Encoding.isoLatin1) else {
				completionHandler(nil, Optional(DokuError.ParseError))
				return
			}
			
			// err if unable to find element
			let xml = SWXMLHash.parse(stringData)
			guard let contents = xml["methodResponse"]["params"]["param"]["value"]["boolean"].element else {
				completionHandler(nil, Optional(DokuError.XMLError)) // todo: 406 mod sec error also ends up here
				return
			}
			
			// if all goes well data should be returned
			completionHandler(contents.text == "1" ? true : false, nil)
		})
	}
	
}

