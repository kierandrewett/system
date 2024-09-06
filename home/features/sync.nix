{
    pkgs,
    config,
    ...
}:
{
    systemd.user.services.rclone-sync = {
        Unit = {
            Description = "Performs a bidirectional sync of data between the client and remote.";
            StartLimitIntervalSec = 0;
        };
        Install = {
            WantedBy = [ "default.target" ];
        };
        Service = {
            Restart = "always";
            RestartSec = 60;
            ExecStart = "${pkgs.writeShellScript "rclone-sync" ''
                cat > /tmp/rclone-nc.conf << EOF
                [nc]
                type = webdav
                url = $(cat ${config.sops.secrets."sync/nc/url".path})
                user = $(cat ${config.sops.secrets."sync/nc/username".path})
                pass = $(cat ${config.sops.secrets."sync/nc/password".path})
                vendor = nextcloud
                EOF

                RCLONE_CONFIG=/tmp/rclone-nc.conf

                SHARED_OPTS="
                    --create-empty-src-dirs \
                    --compare size,modtime,checksum \
                    --slow-hash-sync-only \
                    --resilient \
                    --fix-case \
                    -MvP"

                rclone bisync nc:/ ~/Documents/ $SHARED_OPTS --resync
                rclone bisync nc:/ ~/Documents/ $SHARED_OPTS
            ''}";
        };
    };
}