module OpenSolid.Scene.Light
    exposing
        ( AmbientLookupTexture
        , Light
        , ambient
        , directional
        , loadAmbientLookupTextureFrom
        )

import Color exposing (Color)
import OpenSolid.Direction3d as Direction3d
import OpenSolid.Geometry.Types exposing (..)
import OpenSolid.Scene.Types as Types
import OpenSolid.WebGL.Color as Color
import OpenSolid.WebGL.Direction3d as Direction3d
import Task exposing (Task)
import WebGL exposing (Texture)
import WebGL.Texture


type alias Light =
    Types.Light


type AmbientLookupTexture
    = AmbientLookupTexture WebGL.Texture


ambient : AmbientLookupTexture -> Color -> Light
ambient (AmbientLookupTexture lookupTexture) color =
    Types.AmbientLight
        { color = Color.toVec3 color
        , lookupTexture = lookupTexture
        }


directional : Direction3d -> Color -> Light
directional direction color =
    Types.DirectionalLight
        { color = Color.toVec3 color
        , direction = Direction3d.toVec3 (Direction3d.flip direction)
        }


loadAmbientLookupTextureFrom : String -> Task WebGL.Texture.Error AmbientLookupTexture
loadAmbientLookupTextureFrom url =
    let
        options =
            { magnify = WebGL.Texture.linear
            , minify = WebGL.Texture.linear
            , horizontalWrap = WebGL.Texture.clampToEdge
            , verticalWrap = WebGL.Texture.clampToEdge
            , flipY = True
            }
    in
    WebGL.Texture.loadWith options url |> Task.map AmbientLookupTexture