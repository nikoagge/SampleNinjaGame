//
//  CGPoint+Ext.swift
//  NinjaGame
//
//  Created by Nikolas on 10/4/20.
//  Copyright © 2020 Nikolas Aggelidis. All rights reserved.
//


import CoreGraphics


func + (left: CGPoint, right: CGPoint) -> CGPoint {
    
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}


//All parameters passed into a Swift function are constants, so you can’t change them. If you want, you can pass in one or more parameters as inout, which means they can be changed inside your function, and those changes reflect in the original value outside the function.
func += (left: inout CGPoint, right: CGPoint) {
    
    left = left + right
}


func - (left: CGPoint, right: CGPoint) -> CGPoint {
    
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}


func -= (left: inout CGPoint, right: CGPoint) {
    
    left = left - right
}


func * (left: CGPoint, right: CGPoint) -> CGPoint {
    
    return CGPoint(x: left.x * right.x, y: left.y * right.y)
}


func *= (left: inout CGPoint, right: CGPoint) {
    
    left = left * right
}


func / (left: CGPoint, right: CGPoint) -> CGPoint {
    
    return CGPoint(x: left.x / right.x, y: left.y / right.y)
}


func /= (left: inout CGPoint, right: CGPoint) {
    
    left = left / right
}


func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}


func *= (point: inout CGPoint, scalar: CGFloat) {
    
    point = point * scalar
}


func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}


func /= (point: inout CGPoint, scalar: CGFloat) {
    
    point = point / scalar
}
