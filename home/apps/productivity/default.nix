{
    pkgs,
    ...
}:
{
    home.packages = with pkgs; [
        thunderbird
        libreoffice-bin
    ];
}