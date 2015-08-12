{-# LANGUAGE TupleSections, OverloadedStrings #-}
module Handler.Home where

import Import
import Foundation (appSettings)

import Data.Text.Encoding as S
import Text.XML

-- This is a handler function for the GET request method on the HomeR
-- resource pattern. All of your resource patterns are defined in
-- config/routes
--
-- The majority of the code you will write in Yesod lives in these handler
-- functions. You can spread them across multiple files if you are so
-- inclined, or create a single monolithic file.
getHomeR :: Handler Html
getHomeR = do
    let submission = Nothing :: Maybe (FileInfo, Text)
        handlerName = "getHomeR" :: Text
    defaultLayout $ do
        aDomId <- newIdent
        setTitle "Tabeyou!"
        $(widgetFile "homepage")

getProductsR :: Handler Html
getProductsR = do
	products <- runDB $ selectList [] [Asc ProductName]
	defaultLayout $ do
		$(widgetFile "products")

getTransactionsR :: Handler Html
getTransactionsR = do
    master <- getYesod
    initReq <- parseUrl "https://tabeyou.foxycart.com/api"
    let token = S.encodeUtf8 $ appFoxyCartApiKey $ appSettings master
    let req = (flip urlEncodedBody) initReq $ 
                [("api_action","transaction_list")
                ,("api_token", token)]

    response <- withManager $ httpLbs req
    let transactions = parseLBS_ def $ responseBody response
    defaultLayout $ do
        $(widgetFile "transactions")


-- postHomeR :: Handler Html
-- postHomeR = do
--     ((result, formWidget), formEnctype) <- runFormPost sampleForm
--     let handlerName = "postHomeR" :: Text
--         submission = case result of
--             FormSuccess res -> Just res
--             _ -> Nothing
-- 
--     defaultLayout $ do
--         aDomId <- newIdent
--         setTitle "Welcome To Yesod!"
--         $(widgetFile "homepage")
