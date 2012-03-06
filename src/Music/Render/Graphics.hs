{-|
    Module      :  Music.Render.Graphics
    Copyright   :  Hans Höglund 2012

    Maintainer  :  hans@hanshoglund.se
    Stability   :  experimental
    Portability :  portable
-}

{-# LANGUAGE
    MultiParamTypeClasses,
    FlexibleInstances #-}

module Music.Render.Graphics
(
    Graphic,
    writeGraphics
)
where

import Prelude hiding ( reverse )

import Data.Monoid
import Data.Colour ( withOpacity )
import Data.Colour.SRGB ( sRGB24read )
import Data.Convert

import Diagrams.Prelude hiding ( Render, render )
import Diagrams.Backend.Cairo

import Music.Time
import Music.Time.Score
import Music.Time.EventList
import Music.Internal.Time.Score ( foldScore, unrenderScore )


-- | Opaque type representing a graphic representation.
newtype Graphic = Graphic (Diagram Cairo R2)

instance (Time t, Show a) => Render (EventList t a) Graphic where
    render = renderGraphics . unrenderScore

instance (Time t, Show a) => Render (Score t a) Graphic where
    render = renderGraphics

-- | Writes the given graphic representation to a file.
writeGraphics :: FilePath -> Graphic -> IO ()
writeGraphics file (Graphic diagram) = do
    fst $ renderDia Cairo ( CairoOptions file $ PDF (500, 500) ) diagram
    return ()      
            


--
-- Graphic rendering
--            

renderGraphics :: (Time t, Show a) => Score t a -> Graphic
renderGraphics = Graphic 
        . foldScore (\t d   -> renderRest d)
                    (\t d x -> renderNote d x)
                    (\t x y -> renderPar x y)
                    (\t x y -> renderSeq x y)
        . normalizeDuration
    where
        renderRest d   | d == 0     =  mempty
                       | otherwise  =  moveOriginBy (negate (t2d d), 0) (renderEmpty (t2d d * 2))

        renderNote d x | d == 0     =  mempty
                       | otherwise  =  moveOriginBy (negate (t2d d), 0) (renderText x <> renderBox (t2d d))

        renderPar     =  beside (negateV unitY)
        renderSeq     =  append unitX
        renderEmpty   =  strutX
        renderText x  =  text (show x) # font "Gill Sans"
                                       # fc white
        renderBox d   =  scaleX d . fcA boxColor $ square 2
        boxColor      =  sRGB24read "465FBD" `withOpacity` 0.6    


t2d :: Time t => t -> Double
t2d   = time2Double

