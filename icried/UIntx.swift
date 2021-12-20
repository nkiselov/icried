//
//  UIntx.swift
//  icried
//
//  Created by Nikita Kiselov on 12/18/21.
//

import Foundation

class UIntx:CustomStringConvertible{
    private(set) public var x:Int
    private(set) public var buf:[UInt64]
    public var description: String {get{
        var desc = ""
        for i in 0..<x{
            let j = i/64
            let b = i%64
            desc=String((buf[j] & (1<<b)) >> b)+desc
        }
        return desc
    }}
    
    init(_ x:Int){
        self.x = x
        buf = Array(repeating: 0, count: (x+63)/64)
    }
    
    init(_ x:Int, _ buf:[UInt64]){
        self.x = x
        self.buf = buf
    }
}

func & (lhs:UIntx, rhs:UIntx) -> UIntx{
    var buf:[UInt64] = Array(repeating: 0, count: lhs.buf.count)
    for i in 0..<lhs.buf.count{
        buf[i] = lhs.buf[i] & rhs.buf[i]
    }
    return UIntx(lhs.x,buf)
}

func ^ (lhs:UIntx, rhs:UIntx) -> UIntx{
    var buf:[UInt64] = Array(repeating: 0, count: lhs.buf.count)
    for i in 0..<lhs.buf.count{
        buf[i] = lhs.buf[i] ^ rhs.buf[i]
    }
    return UIntx(lhs.x,buf)
}

func | (lhs:UIntx, rhs:UIntx) -> UIntx{
    var buf:[UInt64] = Array(repeating: 0, count: lhs.buf.count)
    for i in 0..<lhs.buf.count{
        buf[i] = lhs.buf[i] | rhs.buf[i]
    }
    return UIntx(lhs.x,buf)
}

func << (lhs:UIntx, rhs:Int) -> UIntx{
    let r = min(rhs,lhs.x)
    let buf:[UInt64] = Array(repeating: 0, count: lhs.buf.count)
    mv(UnsafeMutablePointer(mutating: buf), Int32(r), UnsafePointer(lhs.buf), 0, Int32(lhs.x-r))
    return UIntx(lhs.x, buf)
}

func >> (lhs:UIntx, rhs:Int) -> UIntx{
    let r = min(rhs,lhs.x)
    let buf:[UInt64] = Array(repeating: 0, count: lhs.buf.count)
    mv(UnsafeMutablePointer(mutating: buf), 0, UnsafePointer(lhs.buf), Int32(r), Int32(lhs.x-r))
    return UIntx(lhs.x, buf)
}

infix operator <<< : BitwiseShiftPrecedence
infix operator >>> : BitwiseShiftPrecedence

func <<< (lhs:UIntx, rhs:Int) -> UIntx{
    let r = rhs%lhs.x
    let buf:[UInt64] = Array(repeating: 0, count: lhs.buf.count)
    let dst = UnsafeMutablePointer(mutating: buf)
    let src = UnsafePointer(lhs.buf)
    let r32 = Int32(r)
    let xr32 = Int32(lhs.x-r)
    mv(dst, r32, src, 0, xr32)
    mv(dst, 0, src, xr32, r32)
    return UIntx(lhs.x, buf)
}

func >>> (lhs:UIntx, rhs:Int) -> UIntx{
    let r = rhs%lhs.x
    let buf:[UInt64] = Array(repeating: 0, count: lhs.buf.count)
    let dst = UnsafeMutablePointer(mutating: buf)
    let src = UnsafePointer(lhs.buf)
    let r32 = Int32(r)
    let xr32 = Int32(lhs.x-r)
    mv(dst, 0, src, r32, xr32)
    mv(dst, xr32, src, 0, r32)
    return UIntx(lhs.x, buf)
}
