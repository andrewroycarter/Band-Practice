//
//  PDFRenderer.swift
//  Band Practice
//
//  Created by Andrew Carter on 10/23/16.
//  Copyright © 2016 Andrew Carter. All rights reserved.
//

import Foundation
import CoreGraphics
import QuartzCore
import AppKit
import CoreText

class PDFRenderer {
    
    struct Page {
        let leftMargin: CGFloat
        let rightMargin: CGFloat
        let topMargin: CGFloat
        let bottomMargin: CGFloat
        let width: CGFloat
        let height: CGFloat
        
        var drawableRect: NSRect {
            return NSRect(x: leftMargin,
                          y: topMargin,
                          width: width,
                          height: height)
        }
    }
    
    func appendHeader(for song: Song, to string: NSMutableAttributedString) {
        string.append(NSAttributedString(string: "\(song.title)\n", attributes:  [
            NSForegroundColorAttributeName: NSColor.black,
            NSFontAttributeName: NSFont.monospacedDigitSystemFont(ofSize: 15.0, weight: 1.0)
            ]))
        
        string.append(NSAttributedString(string: "\(song.artist)\n\n", attributes: [
            NSForegroundColorAttributeName: NSColor.gray,
            NSFontAttributeName: NSFont.monospacedDigitSystemFont(ofSize: 10.0, weight: 0.0)
            ]))
    }
    
    func appendBody(for song: Song, to string: NSMutableAttributedString, constrainedTo page: Page) {
        var fontSize: CGFloat = 12.0
        
        let bodyRange = NSMakeRange(string.string.characters.count, song.body.characters.count)
        let bodyAttributes = [
            NSForegroundColorAttributeName: NSColor.black,
            NSFontAttributeName: NSFont.monospacedDigitSystemFont(ofSize: fontSize, weight: 0.0)
        ]
        string.append(NSAttributedString(string: song.body, attributes: bodyAttributes))
        
        let size = NSSize(width: page.width,
                          height: CGFloat.greatestFiniteMagnitude)
        
        let options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]
        let chords = string.string.chords
        
        chords.forEach { chord in
            let cleanString = chord.string
                .replacingOccurrences(of: "[", with: " ")
                .replacingOccurrences(of: "]", with: " ")
                .trimmingCharacters(in: CharacterSet.whitespaces)
                .padding(toLength: chord.range.length, withPad: " ", startingAt: 0)
            
            
            string.replaceCharacters(in: chord.range, with: cleanString)
        }
        
        repeat {
            let attributes = [NSFontAttributeName: NSFont.monospacedDigitSystemFont(ofSize: fontSize, weight: 0.0)]
            string.addAttributes(attributes, range: bodyRange)
            
            chords.forEach { chord in
                let attributes = [NSFontAttributeName: NSFont.monospacedDigitSystemFont(ofSize: fontSize, weight: 1.0)]
                string.addAttributes(attributes, range: chord.range)
            }
            
            fontSize = fontSize - 0.25
        } while (
            string.boundingRect(with: size, options: options).height > page.height
                && fontSize >= 1.0
        )
    }
    
    func render(song: Song, in context: CGContext, constrainedTo page: Page) {
        let string = NSMutableAttributedString()
        appendHeader(for: song, to: string)
        appendBody(for: song, to: string, constrainedTo: page)
        context.beginPDFPage(nil)
        string.draw(in: page.drawableRect)
        context.endPDFPage()
    }
    
    func renderTitlePage(for book: Book, in context: CGContext, constrainedTo page: Page) {
        context.beginPDFPage(nil)
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        style.lineBreakMode = .byWordWrapping
        
        let string = NSAttributedString(string: book.name,
                                        attributes: [
                                            NSFontAttributeName: NSFont.systemFont(ofSize: 30.0),
                                            NSParagraphStyleAttributeName: style
            ])
        string.draw(in: page.drawableRect)
        context.endPDFPage()
    }
    
}

extension PDFRenderer: Renderer {
    
    func render(book: Book, to url: URL) {
        
        let consumerURL: URL
        if url.hasDirectoryPath {
            consumerURL = url.appendingPathComponent("book.pdf")
        } else {
            consumerURL = url
        }
        
        let consumer = CGDataConsumer(url: consumerURL as NSURL)!
        let context = CGContext(consumer: consumer, mediaBox: nil, nil)!
        
        let graphicsContext = NSGraphicsContext(cgContext: context, flipped: false)
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.setCurrent(graphicsContext)
        
        let page = Page(leftMargin: 20.0,
                        rightMargin: 20.0,
                        topMargin: 40.0,
                        bottomMargin: 40.0,
                        width: 612.0 - 20.0 - 20.0,
                        height: 792.0 - 40.0 - 40.0)
        
        renderTitlePage(for: book, in: context, constrainedTo: page)
        book.songs.forEach { render(song: $0, in: context, constrainedTo: page) }
        
        context.closePDF()
        NSGraphicsContext.restoreGraphicsState()
    }
    
}
