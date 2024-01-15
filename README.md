<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://github.com/nicolodiamante/dotfiles/assets/48920263/5b1458ad-2b94-4d0b-bc20-e07f13c94987" draggable="false" ondragstart="return false;" alt="Dotfiles" title="Dotfiles" />
    <img src="https://github.com/nicolodiamante/dotfiles/assets/48920263/af8cf438-8af7-4460-833a-0b1516303c1d" draggable="false" ondragstart="return false; "alt="Dotfiles" title="Dotfiles" />
  </picture>
</p>

For those who are not familiar, the dotfiles directory is a hidden directory in the user's home directory that contains configuration files for various applications and tools. These files are typically preceded by a dot, hence the name "dotfiles". This project's shell scripts automate the installation of development tools, apps, and symbolic links, making it easy to automate and synchronise your configurations across multiple systems.

<br><br>

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://github.com/nicolodiamante/dotfiles/assets/48920263/27a58ad2-e77e-4dc4-b059-5badc1467775" draggable="false" ondragstart="return false;" alt="Terminal" title="Terminal" />
    <img src="https://github.com/nicolodiamante/dotfiles/assets/48920263/70ce33dd-e9e1-4dbb-a040-2ed415530c13" draggable="false" ondragstart="return false; "alt="Terminal" title="Terminal" width="630px" />
  </picture>
</p>

<br><br>

### Benefits of Dotfiles

- Saves time and effort by automating the installation of development tools.
- Ensures consistency across multiple systems by synchronising configurations.
- Easy to set up and use.
  <br><br>

## Using a cloud service instead of GitHub

As a member of the Apple ecosystem, I decided to streamline my workflow by moving my dotfiles to iCloud Drive. Since I'm already paying for an iCloud subscription, it made sense to take advantage of this cloud storage service to keep all my dotfiles in one place. Putting dotfiles into iCloud Drive can be a great way to keep them synced across all of your Apple devices. However, my latest configuration still remains on Github, allowing me to easily push or pull updates as I make them. This simple sync process ensures that you can keep all your systems in sync and access your dotfiles from anywhere. This streamlined workflow saves you time and effort, making it a convenient and accessible solution for managing your dotfiles.
<br><br>

### What are the benefits of working in the Cloud?

Using a cloud service, like Dropbox, Google Drive, or iCloud Drive, can offer various advantages, especially when it comes to real-time syncing. By storing your dotfiles in the cloud, you can quickly and easily access and edit them from any device, without worrying about manually transferring the latest version. Additionally, you can maintain the same folder structure across all your devices, making it easier to organise and locate your files. You can even use Github as a backup and reference to share your repository with others. This approach ensures that you always have access to the latest version of your configuration, no matter where you are.
<br><br>

<p align="center">
  <picture>
    <img src="https://github.com/nicolodiamante/dotfiles/assets/48920263/6a82f986-d11b-4ca6-8dac-86d2b6affec2" draggable="false" ondragstart="return false; "alt="iCloud Sync Folder" title="iCloud Sync Folder" width="560px" />
  </picture>
</p>

## Getting started

> Before incorporating someone else's dotfiles, it's recommended to review the code thoroughly to ensure that it's compatible with your system and to remove any unnecessary settings. Blindly using someone else's dotfiles without understanding what they do can lead to unintended consequences, so it's important to have a good understanding of what each configuration setting does before applying it to your system.

<br>

### Installation

With the [Bootstrap script][bootstrap], you can easily manage and install packages using [Homebrew][brew], [npm][npm] and [mas][mas]. Once the packages are installed and configured, the macOS settings will be automatically set up for you. The script will then proceed to create a symbolic link of your dotfiles in your home directory, while keeping the original files intact in either iCloud Drive or in your local directory.

Let's get started, download the repository via curl:

```shell
bash -c "$(curl -fsSL https://raw.githubusercontent.com/nicolodiamante/dotfiles/HEAD/bootstrap.sh)"
```

The script will first attempt to clone the repository to `~/Library/Mobile Documents/com~apple~CloudDocs`, which is the path to the iCloud Drive directory for the user. If iCloud Drive is not available, the script will then clone the repository to `~` which is a local directory on the user's system.
<br><br>

### Install Manually

As an alternative, you can download it first:

```shell
git clone https://github.com/nicolodiamante/dotfiles.git ~
```

Navigate to the dotfiles directory and execute the script.

```shell
cd bin && source bootstrap.sh
```

<p align="center">
  <picture>
    <img src="https://github.com/nicolodiamante/dotfiles/assets/48920263/4673ba7d-7304-4931-9a76-27b66a1c9305" draggable="false" ondragstart="return false; "alt="Dotfiles" title="Dotfiles" width="590px" />
  </picture>
</p>

<br>

## Add custom commands without creating a new fork

The user/config feature allows users to add custom commands to their dotfiles without having to fork the entire repository. This is useful for adding commands that users do not want to commit to a public repository. Additionally, users can also create additional files in the user/ directory which will be sourced automatically from the zshrc file and ignored by Git. This provides users with more flexibility in managing their dotfiles and allows them to easily customise their shell environment to suit their needs. With this approach, users can keep their dotfiles organised and easily accessible, while also ensuring that their sensitive information remains private.
<br><br>

## Notes

### Resources

#### Arch Linux

- [Zsh (Wiki)][archw-zsh]

#### Base Directory

- [XDG Base Directory Specification][XDG]

#### Zsh Documentations

- [Documentation Index][zsh-docs]
- [User Guide][zsh-docs-guide]
- [Startup Files][zsh-docs-startup_files]
- [Variable Index][zsh-docs-var_idex]
- [Shell Grammar][zsh-docs-shell_grammar]

### Contribution

Thanks for considering these Dotfiles for your development needs. If you have any ideas on how to improve this project, please feel free to share them. If you encounter any issues or bugs, please report them to the [issues page][issues]. Your feedback is valuable in helping to improve these Dotfiles.
<br><br>

<p align="center">
  <picture>
    <img src="https://github.com/nicolodiamante/dotfiles/assets/48920263/66b4a50a-6cde-4ff0-a706-227b5c0698fc" draggable="false" ondragstart="return false;" /></>
  </picture>
</p>

<p align="center">
  <a href="https://nicolodiamante.com" target="_blank">
    <img src="https://github.com/nicolodiamante/dotfiles/assets/48920263/6ab67548-8a44-4c3c-8b30-e96cd13f38f0" draggable="false" ondragstart="return false;" alt="Nicol&#242; Diamante Portfolio" title="Nicol&#242; Diamante" width="17px" />
  </a>
</p>

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://github.com/nicolodiamante/dotfiles/assets/48920263/32cb905c-f232-48e0-aea5-e1ef4eb5eaea" draggable="false" ondragstart="return false;" alt="MIT License" title="MIT License" />
    <img src="https://github.com/nicolodiamante/dotfiles/assets/48920263/e91f5ce3-7d7c-4926-af81-44507b50bf62" draggable="false" ondragstart="return false; "alt="MIT License" title="MIT License" width="95px" />
  </picture>
</p>

<!-- Link labels: -->

[bootstrap]: bootstrap.sh
[brew]: https://brew.sh
[npm]: https://www.npmjs.com
[mas]: https://github.com/mas-cli/mas
[zsh-docs]: http://zsh.sourceforge.net/Doc
[zsh-docs-guide]: http://zsh.sourceforge.net/Guide/zshguide.html
[zsh-docs-startup_files]: http://zsh.sourceforge.net/Intro/intro_3.html
[zsh-docs-var_idex]: http://zsh.sourceforge.net/Doc/Release/Variables-Index.html
[zsh-docs-shell_grammar]: http://zsh.sourceforge.net/Doc/Release/Shell-Grammar.html
[archw-zsh]: https://wiki.archlinux.org/index.php/zsh
[XDG]: https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
[issues]: https://github.com/nicolodiamante/dotfiles/issues
