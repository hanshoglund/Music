{-|
    Module      :  Music.Dynamics
    Copyright   :  Hans Höglund 2012

    Maintainer  :  hans@hanshoglund.se
    Stability   :  experimental
    Portability :  portable
-}

{-# LANGUAGE 
    MultiParamTypeClasses, 
    FunctionalDependencies #-}

module Music.Dynamics where

type Amplitude = Rational    

class Dynamic p where
    toAmplitude :: p -> Amplitude