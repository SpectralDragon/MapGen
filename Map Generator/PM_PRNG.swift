//
//  PM_PRNG.swift
//  Map Generator
//
//  Created by Carl Wieland on 4/22/15.
//  Copyright (c) 2015 Carl Wieland. All rights reserved.
//

import Foundation
/*
* Copyright (c) 2009 Michael Baczynski, http://www.polygonal.de
*
* Permission is hereby granted, free of charge, to any person obtaining
* a copy of this software and associated documentation files (the
* "Software"), to deal in the Software without restriction, including
* without limitation the rights to use, copy, modify, merge, publish,
* distribute, sublicense, and/or sell copies of the Software, and to
* permit persons to whom the Software is furnished to do so, subject to
* the following conditions:
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
* LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
* OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
* WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

/**
* Implementation of the Park Miller (1988) "minimal standard" linear
* congruential pseudo-random number generator.
*
* For a full explanation visit: http://www.firstpr.com.au/dsp/rand31/
*
* The generator uses a modulus constant (m) of 2^31 - 1 which is a
* Mersenne Prime number and a full-period-multiplier of 16807.
* Output is a 31 bit unsigned integer. The range of values output is
* 1 to 2,147,483,646 (2^31-1) and the seed must be in this range too.
*
* David G. Carta's optimisation which needs only 32 bit integer math,
* and no division is actually *slower* in flash (both AS2 & AS3) so
* it's better to use the double-precision floating point version.
*
* @author Michael Baczynski, www.polygonal.de
*/

open class PM_PRNG
{
    /**
    * set seed with a 31 bit unsigned integer
    * between 1 and 0X7FFFFFFE inclusive. don't use 0!
    */
    open var seed:UInt;
    
    public init()
    {
        seed = 1;
    }
    
    /**
    * provides the next pseudorandom number
    * as an unsigned integer (31 bits)
    */
    open func nextInt()->UInt
    {
        return gen();
    }
    
    /**
    * provides the next pseudorandom number
    * as a float between nearly 0 and nearly 1.0.
    */
    open func nextDouble()->Double
    {
        return Double(gen()) / Double(2147483647);
    }
    
    /**
    * provides the next pseudorandom number
    * as an unsigned integer (31 bits) betweeen
    * a given range.
    */
    open func nextIntRange(_ minIn:UInt, max maxIn:UInt)->UInt
    {
        let min = Double(minIn) - 0.4999;
        let max = Double(maxIn) + 0.4999;
        return UInt(round(Double(min) + (Double(max - min) * nextDouble())));
    }
    
    /**
    * provides the next pseudorandom number
    * as a float between a given range.
    */
    open func nextDoubleRange(_ min:Double, max:Double)->Double
    {
        return min + ((max - min) * nextDouble());
    }
    
    /**
    * generator:
    * new-value = (old-value * 16807) mod (2^31 - 1)
    */
    fileprivate func gen()->UInt
    {
        //integer version 1, for max int 2^46 - 1 or larger.
        seed = (seed * 16807) % 2147483647;
        
        return seed
        
        /**
        * integer version 2, for max int 2^31 - 1 (slowest)
        */
        //var test:int = 16807 * (seed % 127773 >> 0) - 2836 * (seed / 127773 >> 0);
        //return seed = (test > 0 ? test : test + 2147483647);
        
        /**
        * david g. carta's optimisation is 15% slower than integer version 1
        */
        //var hi:uint = 16807 * (seed >> 16);
        //var lo:uint = 16807 * (seed & 0xFFFF) + ((hi & 0x7FFF) << 16) + (hi >> 15);
        //return seed = (lo > 0x7FFFFFFF ? lo - 0x7FFFFFFF : lo);
    }
}
