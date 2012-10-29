{-# LANGUAGE OverloadedStrings #-}

module Main where

import Prelude hiding (id)
import Control.Category (id)
import Control.Arrow ((>>>), (***), arr)
import Data.Monoid (mempty, mconcat)

import Hakyll

type SPage = Page String 

main :: IO ()
main = hakyll $ do

    -- To avoid a dependency cycle we need to process the blog posts
    -- twice.
    --
    posts <- group "posts" $ match "posts/*.md" $ do
                  route   $ setExtension ".html"
                  compile pageCompiler

    -- Compress CSS
    _ <- match "css/*" $ do
           route   idRoute
           compile compressCssCompiler

    -- Copy images
    _ <- match "images/*" $ do
           route   idRoute
           compile copyFileCompiler

    -- Read templates
    _ <- match "templates/*" $ compile templateCompiler

    -- Render posts
    _ <- match "posts/*.md" $ do
           route   $ setExtension ".html"
           compile $ pageCompiler
               >>> requireAllA posts addNearbyPosts
               >>> applyTemplateCompiler "templates/neighbours.html"
               >>> applyTemplateCompiler "templates/post.html"
               >>> applyTemplateCompiler "templates/default.html"
	       -- QUS: why does this not 'fix' the URLs for the next/prev
               --      links?
               >>> relativizeUrlsCompiler

    -- Render data files
    _ <- match "data/*" $ do
           route   idRoute
           compile copyFileCompiler

    -- Create introduction and acknowledgements pages
    _ <- match "intro.md" $ do
          route   $ setExtension ".html"
          compile $ pageCompiler
               >>> applyTemplateCompiler "templates/default.html"
               >>> relativizeUrlsCompiler

    _ <- match "acknowledge.md" $ do
          route   $ setExtension ".html"
          compile $ pageCompiler
               >>> applyTemplateCompiler "templates/default.html"
               >>> relativizeUrlsCompiler

    -- Render posts list (because I did not think about this we
    -- have two pages with all the posts; could use a re-direct?)
    --
    match "posts.html" $ route idRoute
    match "posts/index.html" $ route idRoute
    _ <- create "posts.html" $ allPosts posts
    _ <- create "posts/index.html" $ allPosts posts

    -- Create index
    match "index.html" $ route idRoute
    create "index.html" $ constA mempty
        >>> arr (setField "title" "Home")
        >>> requireAllA posts (id *** arr (take 3 . recentFirst) >>> addPostList)
        >>> applyTemplateCompiler "templates/index.html"
        >>> applyTemplateCompiler "templates/default.html"
        >>> relativizeUrlsCompiler

renderTemplate :: Identifier Template -> Compiler [SPage] [SPage]
renderTemplate t = require t (\p tt -> map (applyTemplate tt) p)

-- | Auxiliary compiler: generate a post list from a list of given posts, and
-- add it to the current page under @$posts@
--
addPostList :: Compiler (SPage, [SPage]) SPage
addPostList = setFieldA "posts" $
    arr recentFirst
        >>> renderTemplate "templates/postitem.html"
        >>> arr mconcat
        >>> arr pageBody

get0 :: [a] -> [a]
get0 (a:_) = [a]
get0 _     = []

get1 :: [a] -> [a]
get1 (_:a:_) = [a]
get1 _       = []

-- | Given a post and a list of all posts, return the
--   preceeding and following posts, if they exist.
--
findNeighbours :: Compiler (SPage, [SPage]) (SPage, ([SPage], [SPage]))
findNeighbours = 
    arr $ \(cpage, plist) ->
        let slist = chronological plist
            (earlier, later) = break (==cpage) slist
        in (cpage, (get0 (reverse earlier), get1 later))

-- should be read from a file rather than hard coded
prevTemplate, nextTemplate :: String
prevTemplate = "<div class='previouspost'><a href='$url$'>$title$</a><br/><span class='label'>previous post</span></div>"
nextTemplate = "<div class='followingpost'><a href='$url$'>$title$</a><br/><span class='label'>next post</span></div>"

-- | Add in the previous and next links for a post
--
addNearbyPosts :: Compiler (SPage, [SPage]) SPage
addNearbyPosts = 
    arr (id *** recentFirst)
    >>> findNeighbours
    >>> setFieldA "neighbours"
        (arr (\(as,bs) -> 
          map (applyTemplate (readTemplate prevTemplate)) as 
          ++
          map (applyTemplate (readTemplate nextTemplate)) bs)
         >>> arr mconcat >>> arr pageBody)

-- | Construct a page listing all the posts.
--
allPosts :: Pattern SPage -> Compiler () SPage
allPosts posts = constA mempty
        >>> arr (setField "title" "All posts")
        >>> requireAllA posts addPostList
        >>> applyTemplateCompiler "templates/posts.html"
        >>> applyTemplateCompiler "templates/default.html"
        >>> relativizeUrlsCompiler

