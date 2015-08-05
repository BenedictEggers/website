--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll


--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "typewriter/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html" postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    match "pages/*" $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    match "*.markdown" $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    create ["typewriter.html"] $ do
        route idRoute
        compile $ do
            posts <- loadAll "typewriter/*"
            postTpl <- loadBody "templates/typewriter-item.html"

            posts' <- applyTemplateList postTpl postCtx posts

            let typewriterCtx =
                    constField "title" "Typewriter Odyssey" `mappend`
                    constField "typewriter-posts" posts'    `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/typewriter.html" typewriterCtx
                >>= loadAndApplyTemplate "templates/default.html" typewriterCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateCompiler


postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext

projectCtx :: Context String
projectCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext
