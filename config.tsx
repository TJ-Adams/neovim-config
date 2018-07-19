import * as React from "react"
import * as Oni from "oni-api"

/////////////////////////////////////////
//  README
//
//  This lives in the shared vim config git repo - on *nix platforms
//  it can be safely symlinked to $HOME/.config/oni/config.tsx, on
//  Windows it likely must be manually copied to %APPDATA%/oni/config.tsx
/////////////////////////////////////////

export const activate = (oni: Oni.Plugin.Api) => {
    console.log("config activated")

    // Input
    //
    // Add input bindings here:
    //
    oni.input.bind("<c-enter>", () => console.log("Control+Enter was pressed"))

    //
    // Or remove the default bindings here by uncommenting the below line:
    //
    // oni.input.unbind("<c-p>")

}

export const deactivate = (oni: Oni.Plugin.Api) => {
    console.log("config deactivated")
}

export const configuration = {
    // Enable the browser
    "browser.enabled": true,
    "browser.defaultUrl": "https://google.com",
    "snippets.enabled": true,

    // Don't use ONI's config defaults that conflict
    "oni.useDefaultConfig": false,
    // Can be updated to be a path to the init.vim file if Oni isn't
    // happy with its default location (@Windows)
    "oni.loadInitVim": true,

    "editor.fontSize": "14px"
    "editor.fontFamily": "Source Code Pro for Powerline",

    // UI customizations
    "ui.colorscheme": "nord",
    "ui.animations.enabled": true,
    "ui.fontSmoothing": "auto",
    "sidebar.plugins.enabled": true,

    // Use buffers, not Tabs for the tab bar
    "tabs.mode": "buffers",

    // Disable ONI's statusbar in favor of airline
    "statusbar.enabled": false,
}
