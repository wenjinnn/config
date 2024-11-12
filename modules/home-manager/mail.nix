{
  pkgs,
  config,
  username,
  outlook,
  gmail,
  ...
}: let
  # for the follow script will be used in systemd unit, so we don't use ${sops_secrets} here
  sops_secrets = "${config.home.homeDirectory}/project/my/config/secrets.yaml";
  mutt_oauth2 = "${pkgs.neomutt}/share/neomutt/oauth2/mutt_oauth2.py";
  # outlook token setup
  outlook_oauth2_token_path = "${config.home.homeDirectory}/.cache/neomutt/${outlook}.tokens";
  init_outlook_oauth2_token = pkgs.writeShellScript "init_outlook_oauth2_token" ''
    ${mutt_oauth2} ${outlook_oauth2_token_path} \
    --verbose \
    --authorize \
    --provider microsoft \
    --client-id $(sops exec-env ${sops_secrets} 'echo -e $OUTLOOK_CLIENT_ID') \
    --client-secret "" \
    --authflow localhostauthcode \
    --email ${outlook}
  '';
  outlook_oauth2_token = pkgs.writeShellScript "outlook_oauth2_token" ''
    ${mutt_oauth2} ${outlook_oauth2_token_path}
  '';
  # gmail token setup
  gmail_oauth2_token_path = "${config.home.homeDirectory}/.cache/neomutt/${gmail}.tokens";
  init_gmail_oauth2_token = pkgs.writeShellScript "init_gmail_oauth2_token" ''
    ${mutt_oauth2} ${gmail_oauth2_token_path} \
    --verbose \
    --authorize \
    --provider google \
    --client-id $(sops exec-env ${sops_secrets} 'echo -e $GMAIL_CLIENT_ID') \
    --client-secret "$(sops exec-env ${sops_secrets} 'echo -e $GMAIL_CLIENT_SECRET')" \
    --authflow localhostauthcode \
    --email ${gmail}
  '';
  gmail_oauth2_token = pkgs.writeShellScript "gmail_oauth2_token" ''
    ${mutt_oauth2} ${gmail_oauth2_token_path}
  '';
in {
  home.file = {
    ".local/bin/init_gmail_oauth2_token".source = init_gmail_oauth2_token;
    ".local/bin/init_outlook_oauth2_token".source = init_outlook_oauth2_token;
  };

  accounts.email.accounts = {
    ${outlook} = {
      realName = "${username}";
      userName = "${outlook}";
      address = "${outlook}";
      primary = true;
      maildir.path = "${outlook}";
      neomutt.enable = true;
      notmuch.enable = true;
      passwordCommand = "${outlook_oauth2_token}";
      imapnotify = {
        enable = true;
        boxes = ["Inbox"];
        onNotifyPost = ''${pkgs.libnotify}/bin/notify-send "New Mail Received:" "${outlook}"'';
        onNotify = "${pkgs.offlineimap}/bin/offlineimap -a ${outlook} && notmuch new";
        extraConfig = {
          xoAuth2 = true;
        };
      };
      imap = {
        host = "outlook.office365.com";
        tls.enable = true;
        port = 993;
      };
      smtp = {
        host = "smtp-mail.outlook.com";
        port = 587;
        tls.enable = true;
        tls.useStartTls = true;
      };
      offlineimap = {
        enable = true;
        extraConfig = {
          remote = {
            remotepasseval = false;
            auth_mechanisms = "XOAUTH2";
            oauth2_request_url = "https://login.microsoftonline.com/common/oauth2/v2.0/token";
            oauth2_client_id_eval = ''get_output("sops exec-env ${sops_secrets} 'echo -e $OUTLOOK_CLIENT_ID'")'';
            oauth2_client_secret = "";
            oauth2_access_token_eval = ''get_output("${outlook_oauth2_token}")'';
          };
        };
      };
      msmtp = {
        enable = true;
        extraConfig = {
          auth = "xoauth2";
          passwordeval = "${outlook_oauth2_token}";
        };
      };
    };
    ${gmail} = {
      realName = "${username}";
      userName = "${gmail}";
      address = "${gmail}";
      maildir.path = "${gmail}";
      neomutt.enable = true;
      notmuch.enable = true;
      passwordCommand = "${gmail_oauth2_token}";
      imapnotify = {
        enable = true;
        boxes = ["Inbox"];
        onNotifyPost = ''${pkgs.libnotify}/bin/notify-send "New Mail Received:" "${gmail}"'';
        onNotify = "${pkgs.offlineimap}/bin/offlineimap -a ${gmail} && notmuch new";
        extraConfig = {
          xoAuth2 = true;
        };
      };
      imap = {
        host = "imap.gmail.com";
        tls.enable = true;
        port = 993;
      };
      smtp = {
        host = "smtp.gmail.com";
        port = 587;
        tls.enable = true;
        tls.useStartTls = true;
      };
      offlineimap = {
        enable = true;
        extraConfig = {
          local = {
            type = "GmailMaildir";
          };
          remote = {
            type = "Gmail";
            remotepasseval = false;
            auth_mechanisms = "XOAUTH2";
            oauth2_request_url = "https://oauth2.googleapis.com/token";
            oauth2_client_id_eval = ''get_output("sops exec-env ${sops_secrets} 'echo -e $GMAIL_CLIENT_ID'")'';
            oauth2_client_secret_eval = ''get_output("sops exec-env ${sops_secrets} 'echo -e $GMAIL_CLIENT_SECRET'")'';
            oauth2_access_token_eval = ''get_output("${gmail_oauth2_token}")'';
            nametrans = ''
              lambda foldername: re.sub ('^\[Gmail\]\/', ''',
                                 re.sub ('Sent_Mail', 'Sent',
                                 re.sub (' ', '_', foldername.title())))
            '';
            folderfilter = ''lambda foldername: foldername not in ['[Gmail]/All Mail']'';
          };
        };
      };
      msmtp = {
        enable = true;
        extraConfig = {
          auth = "xoauth2";
          passwordeval = "${gmail_oauth2_token}";
        };
      };
    };
  };

  programs = {
    neomutt = {
      enable = true;
      vimKeys = true;
    };
    notmuch.enable = true;
    msmtp.enable = true;
    offlineimap = {
      enable = true;
      pythonFile = ''
        import subprocess

        def get_output(cmd):
            return subprocess.check_output(cmd, shell=True).decode('utf8')
      '';
    };
  };

  services.imapnotify.enable = true;
}