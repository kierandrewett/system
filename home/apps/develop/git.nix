_:
{
    programs.git = {
        enable = true;
        userName = "kierandrewett";
        userEmail = "kieran@dothq.org";

        extraConfig = {
            safe.directory = [
                "/etc/nixos"
            ];
        };
    };
}