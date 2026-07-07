{ pkgs, ... }:
{
  # VSCode 本体は Homebrew(cask) 管理のため package = null にして
  # home-manager は設定・キーバインド・拡張だけを宣言管理する。
  programs.vscode = {
    enable = true;
    package = null;
    # marketplace 手動インストール分（Amazon Q 等 nixpkgs/marketplace 未収録）を消さない
    mutableExtensionsDir = true;

    profiles.default = {
      extensions =
        [ pkgs.vscode-extensions."42crunch".vscode-openapi ]
        ++ (with pkgs.vscode-extensions; [
          anthropic.claude-code
          dbaeumer.vscode-eslint
          eamodio.gitlens
          esbenp.prettier-vscode
          humao.rest-client
          marp-team.marp-vscode
          mhutchie.git-graph
          ms-ceintl.vscode-language-pack-ja
          ms-vscode-remote.remote-containers
          ms-vscode-remote.remote-ssh
          ms-vscode-remote.remote-ssh-edit
          ms-vscode.remote-explorer
          ms-vsliveshare.vsliveshare
          prisma.prisma
          redhat.vscode-yaml
          vscodevim.vim
          # yzane.markdown-pdf は chromium 依存が aarch64-darwin 未対応のため
          # 宣言管理から除外（必要なら手動インストール、mutableExtensionsDir で共存）
        ])
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "vscode-typescript-next";
            publisher = "ms-vscode";
            version = "6.0.20260416";
            sha256 = "163f7788f2zxybn4rn2ydf3iqdy0gi1cfvrqq7hq69w8mpfwynzy";
          }
        ];

      userSettings = {
        "window.newWindowDimensions" = "maximized";

        # Editor settings
        "editor.lineNumbers" = "on";
        "editor.tabSize" = 2;
        "editor.insertSpaces" = true;
        "editor.detectIndentation" = false;
        "editor.autoIndent" = "full";
        "editor.rulers" = [ 80 120 ];
        "editor.renderWhitespace" = "boundary";
        "editor.minimap.enabled" = false;
        "editor.formatOnSave" = true;
        "editor.formatOnType" = true;
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
        "editor.codeActionsOnSave" = {
          "source.fixAll.biome" = "explicit";
        };
        "editor.inlineSuggest.enabled" = true;
        "editor.unicodeHighlight.nonBasicASCII" = false;
        "editor.unicodeHighlight.invisibleCharacters" = false;
        "editor.unicodeHighlight.ambiguousCharacters" = false;

        # Vim settings
        "vim.leader" = "<space>";
        "vim.handleKeys" = {
          "<C-f>" = false;
          "<C-w>" = false;
        };
        "vim.insertModeKeyBindings" = [
          { before = [ "j" "k" ]; after = [ "<Esc>" ]; }
        ];
        "vim.normalModeKeyBindingsNonRecursive" = [
          { before = [ "k" ]; after = [ "g" "k" ]; }
          { before = [ "j" ]; after = [ "g" "j" ]; }
          { before = [ "K" ]; after = [ "1" "0" "k" ]; }
          { before = [ "J" ]; after = [ "1" "0" "j" ]; }
          { before = [ "H" ]; after = [ "0" ]; }
          { before = [ "L" ]; after = [ "$" ]; }
          { before = [ "x" ]; after = [ "\"" "_" "x" ]; }
          { before = [ "d" "d" ]; after = [ "\"" "_" "d" "d" ]; }
          { before = [ "D" ]; after = [ "\"" "_" "D" ]; }
          { before = [ "<leader>" "d" "d" ]; after = [ "d" "d" ]; }
          { before = [ "g" "k" ]; commands = [ "editor.action.showHover" ]; }
          { before = [ "g" "f" ]; commands = [ "editor.action.formatDocument" ]; }
          { before = [ "g" "r" ]; commands = [ "editor.action.goToReferences" ]; }
          { before = [ "g" "d" ]; commands = [ "editor.action.revealDefinition" ]; }
          { before = [ "g" "D" ]; commands = [ "editor.action.revealDeclaration" ]; }
          { before = [ "g" "i" ]; commands = [ "editor.action.goToImplementation" ]; }
          { before = [ "g" "t" ]; commands = [ "editor.action.goToTypeDefinition" ]; }
          { before = [ "g" "n" ]; commands = [ "editor.action.rename" ]; }
          { before = [ "g" "a" ]; commands = [ "editor.action.quickFix" ]; }
          { before = [ "g" "e" ]; commands = [ "editor.action.showHover" ]; }
          { before = [ "g" "]" ]; commands = [ "editor.action.marker.next" ]; }
          { before = [ "g" "[" ]; commands = [ "editor.action.marker.prev" ]; }
        ];
        "vim.visualModeKeyBindingsNonRecursive" = [
          { before = [ "k" ]; after = [ "g" "k" ]; }
          { before = [ "j" ]; after = [ "g" "j" ]; }
          { before = [ "K" ]; after = [ "1" "0" "k" ]; }
          { before = [ "J" ]; after = [ "1" "0" "j" ]; }
          { before = [ "H" ]; after = [ "0" ]; }
          { before = [ "L" ]; after = [ "$" ]; }
        ];
        "vim.hlsearch" = true;
        "vim.useSystemClipboard" = true;
        "vim.matchpairs" = "(:),{:},[:],<:>";
        "vim.showcmd" = true;
        "vim.autoindent" = true;
        "vim.visualstar" = true;
        "vim.incsearch" = true;
        "vim.useCtrlKeys" = true;

        # Workbench settings
        "workbench.iconTheme" = "ayu";
        "workbench.colorTheme" = "Ayu Mirage Bordered";
        "workbench.statusBar.visible" = true;
        "workbench.settings.applyToAllProfiles" = [ ];

        # Terminal settings
        "terminal.integrated.shell.osx" = "/usr/local/bin/zsh";
        "terminal.integrated.fontFamily" = "MesloLGS NF";
        "terminal.integrated.fontSize" = 14;

        # Explorer settings
        "explorer.confirmDelete" = false;

        # File settings
        "files.encoding" = "utf8";
        "files.trimTrailingWhitespace" = true;
        "files.autoGuessEncoding" = true;
        "files.autoSaveDelay" = 1000;
        "files.exclude" = {
          "**/.git" = true;
          "**/.svn" = true;
          "**/.hg" = true;
          "**/CVS" = true;
          "**/.DS_Store" = true;
          "**/*.swp" = true;
          "**/*.swo" = true;
        };

        # Search settings
        "search.smartCase" = true;

        # Security settings
        "security.workspace.trust.untrustedFiles" = "open";

        # Git settings
        "git.autofetch" = true;

        # Live Preview settings
        "livePreview.debugOnExternalPreview" = true;
        "livePreview.notifyOnOpenLooseFile" = false;

        # GitHub Copilot settings
        "github.copilot.editor.enableAutoCompletions" = true;
        "github.copilot.chat.terminalChatLocation" = "terminal";
        "github.copilot.advanced" = {
          "authProvider" = "github";
        };

        # Language-specific
        "[markdown]" = {
          "editor.wordWrap" = "on";
          "editor.quickSuggestions" = {
            "comments" = "off";
            "strings" = "off";
            "other" = "off";
          };
        };
        "[javascriptreact]" = {
          "editor.defaultFormatter" = "biomejs.biome";
        };
        "[typescript]" = {
          "editor.defaultFormatter" = "biomejs.biome";
        };
        "[typescriptreact]" = {
          "editor.defaultFormatter" = "biomejs.biome";
        };
      };

      keybindings = [
        # window
        { key = "ctrl+w h"; command = "workbench.action.navigateLeft"; when = "vim.active && vim.mode != 'Insert'"; }
        { key = "ctrl+w j"; command = "workbench.action.navigateDown"; when = "vim.active && vim.mode != 'Insert'"; }
        { key = "ctrl+w k"; command = "workbench.action.navigateUp"; when = "vim.active && vim.mode != 'Insert'"; }
        { key = "ctrl+w l"; command = "workbench.action.navigateRight"; when = "vim.active && vim.mode != 'Insert'"; }
        { key = "ctrl+w shift+\\"; command = "workbench.action.splitEditorRight"; when = "vim.active && vim.mode != 'Insert'"; }
        { key = "ctrl+w oem_minus"; command = "workbench.action.splitEditorDown"; when = "vim.active && vim.mode != 'Insert'"; }
        { key = "ctrl+w d"; command = "workbench.action.closeActiveEditor"; when = "vim.active && vim.mode != 'Insert'"; }
        # explorer
        { key = "space e"; command = "workbench.view.explorer"; when = "viewContainer.workbench.view.explorer.enabled && !explorerViewletVisible && !searchViewletVisible && !inDebugMode && vim.mode != 'SearchInProgressMode' && vim.mode != 'Insert' && !terminalFocus && !view.workbench.panel.chat.view.copilot.visible"; }
        { key = "a"; command = "explorer.newFile"; when = "explorerViewletVisible && filesExplorerFocus && !explorerResourceReadonly && !inputFocus"; }
        { key = "shift+a"; command = "explorer.newFolder"; when = "explorerViewletVisible && filesExplorerFocus && !explorerResourceReadonly && !inputFocus"; }
        # copilot
        { key = "space c c"; command = "workbench.panel.chat.view.copilot.focus"; when = "viewContainer.workbench.view.explorer.enabled && !explorerViewletVisible && !searchViewletVisible && !inDebugMode && vim.mode != 'SearchInProgressMode' && vim.mode != 'Insert' && !terminalFocus && !view.workbench.panel.chat.view.copilot.visible"; }
        { key = "escape"; command = "workbench.action.toggleSidebarVisibility"; when = "sideBarVisible"; }
        # editor
        { key = "space w"; command = "workbench.action.files.save"; when = "!searchViewletVisible && !inDebugMode && vim.mode != 'SearchInProgressMode' && vim.active && vim.mode != 'Insert' && !terminalFocus && !view.workbench.panel.chat.view.copilot.visible"; }
        { key = "space /"; command = "editor.action.commentLine"; when = "!searchViewletVisible && !inDebugMode && vim.mode != 'SearchInProgressMode' && vim.active && editorTextFocus && vim.mode != 'Insert' && !terminalFocus && !view.workbench.panel.chat.view.copilot.visible"; }
        # buffer
        { key = "space d"; command = "workbench.action.closeActiveEditor"; when = "!searchViewletVisible && !inDebugMode && vim.mode != 'SearchInProgressMode' && vim.active && vim.mode != 'Insert' && !terminalFocus && !view.workbench.panel.chat.view.copilot.visible"; }
        { key = "space ["; command = "workbench.action.previousEditor"; when = "!searchViewletVisible && !inDebugMode && vim.mode != 'SearchInProgressMode' && vim.active && vim.mode != 'Insert' && !terminalFocus && !view.workbench.panel.chat.view.copilot.visible"; }
        { key = "space ]"; command = "workbench.action.nextEditor"; when = "!searchViewletVisible && !inDebugMode && vim.mode != 'SearchInProgressMode' && vim.active && vim.mode != 'Insert' && !terminalFocus && !view.workbench.panel.chat.view.copilot.visible"; }
        # terminal
        { key = "space t t"; command = "workbench.action.terminal.toggleTerminal"; when = "!searchViewletVisible && !inDebugMode && vim.mode != 'SearchInProgressMode' && vim.active && vim.mode != 'Insert' && !terminalFocus && !view.workbench.panel.chat.view.copilot.visible"; }
      ];
    };
  };
}
