# tgui

## Introduction

tgui is a robust user interface framework of /tg/station.

tgui is very different from most UIs you will encounter in BYOND programming.
It is heavily reliant on Javascript and web technologies as opposed to DM.
If you are familiar with NanoUI (a library which can be found on almost
every other SS13 codebase), tgui should be fairly easy to pick up.

## Learn tgui

People come to tgui from different backgrounds and with different
learning styles. Whether you prefer a more theoretical or a practical
approach, we hope you’ll find this section helpful.

### Practical Tutorial

If you are completely new to frontend and prefer to **learn by doing**,
start with our [practical tutorial](docs/tutorial-and-examples.md).

### Guides

This project uses **Inferno** - a very fast UI rendering engine with a similar
API to React. Take your time to read these guides:

- [React guide](https://reactjs.org/docs/hello-world.html)
- [Inferno documentation](https://infernojs.org/docs/guides/components) -
highlights differences with React.

If you were already familiar with an older, Ractive-based tgui, and want
to translate concepts between old and new tgui, read this
[interface conversion guide](docs/converting-old-tgui-interfaces.md).

## Pre-requisites

You will need these programs to start developing in tgui:

- [Node v12.13+](https://nodejs.org/en/download/)
- [Yarn v1.19+](https://yarnpkg.com/en/docs/install) (optional)
- [MSys2](https://www.msys2.org/) (optional)

> MSys2 closely replicates a unix-like environment which is necessary for
> the `bin/tgui` script to run. It comes with a robust "mintty" terminal
> emulator which is better than any standard Windows shell, it supports
> "git" out of the box (almost like Git for Windows, but better), has
> a "pacman" package manager, and you can install a text editor like "vim"
> for a full boomer experience.

## Usage

**For MSys2, Git Bash, WSL, Linux or macOS users:**

First and foremost, change your directory to `tgui`.

Run `bin/tgui --install-git-hooks` to install merge drivers which will
assist you in conflict resolution when rebasing your branches. Only has
to be done once.

Run `bin/tgui` with any of the options listed below.

**For Windows CMD or PowerShell users:**

If you haven't opened the console already, you can do that by holding
Shift and right clicking on the `tgui` folder, then pressing
either `Open command window here` or `Open PowerShell window here`.

Run `.\bin\tgui.bat` with any of the options listed below.

> If using PowerShell, you will receive errors if trying to run
> `.\bin\tgui.ps1`, because default Windows policy does not allow direct
> execution of PS1 scripts. Run `.\bin\tgui.bat` instead.

**For everyone else:**

You can double-click these batch files to achieve the same thing:

- `bin\tgui.bat` - Build the project in production mode.
- `bin\tgui-dev-server.bat` - Launch a development server.

> Remember to always run a full build before submitting a PR. It creates
> a compressed javascript bundle which is then referenced from DM code.
> We prefer to keep it version controlled, so that people could build the
> game just by using Dream Maker.

## Troubleshooting

**Development server doesn't find my BYOND cache!**

This happens if your Documents folder in Windows has a custom location, for
example in `E:\Libraries\Documents`. Development server has no knowledge
of these non-standard locations, therefore you have to run the dev server
with an additional environmental variable, with a full path to BYOND cache.

```
export BYOND_CACHE="E:/Libraries/Documents/BYOND/cache"
bin/tgui --dev
```

Note that in Windows, you have to go through Advanced System Settings,
System Properties and then open Environment Variables window to do the
same thing. You may need to reboot after this.

## Developer Tools

When developing with `tgui-dev-server`, you will have access to certain
development only features.

**Debug Logs.**
When running server via `bin/tgui --dev --debug`, server will print debug
logs and time spent on rendering. Use this information to optimize your
code, and try to keep re-renders below 16ms.

**Kitchen Sink.**
Press `F12` to open the KitchenSink interface. This interface is a
playground to test various tgui components.

**Layout Debugger.**
Press `F11` to toggle the *layout debugger*. It will show outlines of
all tgui elements, which makes it easy to understand how everything comes
together, and can reveal certain layout bugs which are not normally visible.

## Project Structure

- `/packages` - Each folder here represents a self-contained Node module.
- `/packages/common` - Helper functions
- `/packages/tgui/index.js` - Application entry point.
- `/packages/tgui/components` - Basic UI building blocks.
- `/packages/tgui/interfaces` - Actual in-game interfaces.
Interface takes data via the `state` prop and outputs an html-like stucture,
which you can build using existing UI components.
- `/packages/tgui/layouts` - Root level UI components, that affect the final
look and feel of the browser window. They usually hold various window
elements, like the titlebar and resize handlers, and control the UI theme.
- `/packages/tgui/routes.js` - This is where tgui decides which interface to
pull and render.
- `/packages/tgui/layout.js` - A root-level component, holding the
window elements, like the titlebar, buttons, resize handlers. Calls
`routes.js` to decide which component to render.
- `/packages/tgui/styles/main.scss` - CSS entry point.
- `/packages/tgui/styles/functions.scss` - Useful SASS functions.
Stuff like `lighten`, `darken`, `luminance` are defined here.
- `/packages/tgui/styles/atomic` - Atomic CSS classes.
These are very simple, tiny, reusable CSS classes which you can use and
combine to change appearance of your elements. Keep them small.
- `/packages/tgui/styles/components` - CSS classes which are used
in UI components. These stylesheets closely follow the
[BEM](https://en.bem.info/methodology/) methodology.
- `/packages/tgui/styles/interfaces` - Custom stylesheets for your interfaces.
Add stylesheets here if you really need a fine control over your UI styles.
- `/packages/tgui/styles/layouts` - Layout-related styles.
- `/packages/tgui/styles/themes` - Contains all the various themes you can
use in tgui. Each theme must be registered in `webpack.config.js` file.

## Component Reference

See: [Component Reference](docs/component-reference.md).

## License

Source code is covered by /tg/station's parent license - **AGPL-3.0**
(see the main [README](../README.md)), unless otherwise indicated.

Some files are annotated with a copyright header, which explicitly states
the copyright holder and license of the file. Most of the core tgui
source code is available under the **MIT** license.

The Authors retain all copyright to their respective work here submitted.
