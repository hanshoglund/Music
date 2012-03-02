{-|
    Module      :  Music.Pitch
    Copyright   :  Hans Höglund 2012

    Maintainer  :  hans@hanshoglund.se
    Stability   :  experimental
    Portability :  portable
-}

{-# LANGUAGE 
    MultiParamTypeClasses, 
    FlexibleInstances,
    GeneralizedNewtypeDeriving #-}

module Music.Pitch 
where

import Data.Convert
import Music.Time

-- | Frequency in Hertz    
type Frequency = Double

-- | Logarithmic pitch reprentation.
--
-- > convert (f * 2) = convert f + Octave 1    
newtype Octave = Octave Frequency
    deriving ( Show, Eq, Enum, Num, Ord, Fractional, Floating )

-- | Logarithmic pitch reprentation.    
--
-- > convert (f * 2) = convert f + Cent 1200    
newtype Cent   = Cent   Frequency
    deriving ( Show, Eq, Enum, Num, Ord, Fractional, Floating )

instance Convert Frequency Octave  where
    convert f             =  Octave (logBase 2 f)
    reconvert (Octave f)  =  2 ** f

instance Convert Cent Octave       where
    convert (Cent f)      =  Octave (f / 1200)
    reconvert (Octave f)  =  Cent   (f * 1200)

instance Convert Frequency Cent    where
    convert f           =  Cent   (logBase 2 f * 1200)
    reconvert (Cent f)  =  2 ** (f / 1200)



unitFrequency :: Frequency
unitFrequency = 1

unitOctave :: Octave
unitOctave = Octave 0

unitCent :: Cent
unitCent = Cent 0


class Pitched t p where
--    composePitch :: (t -> Frequency -> Frequency) -> p -> p

    -- | @frequency x t@ returns the frequency of the pitched value @x@ at the time @t@.
    frequency :: p -> t -> Frequency
                             

instance (Time t, Temporal d, Pitched t p) => Pitched t (d p) where
    frequency = undefined



