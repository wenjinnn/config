{
  pkgs,
  username,
  ...
}: {
  services = {
    offlineimap = {
      enable = true;
      install = true;
      path = with pkgs; [
        bash
        notmuch
        gnupg
        sops
      ];
    };
    # setup lmtp and rss2email for read local rss source
    dovecot2 = {
      enable = true;
      enableLmtp = true;
      mailLocation = "maildir:~/Maildir/%u/Inbox";
    };
    rss2email = {
      enable = true;
      to = "${username}";
      interval = "1h";
      config = {
        sendmail = "/run/wrappers/bin/sendmail";
        email-protocol = "lmtp";
        lmtp-server = "/var/run/dovecot2/lmtp";
        lmtp-auth = "False";
      };
      feeds = {
        hacknews.url = "https://rsshub.app/hackernews";
        hyprland.url = "https://hyprland.org/rss.xml";
        neovim.url = "https://neovim.io/news.xml";
      };
    };
  };
}