{
  description = "PROS for Vex robots";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixpkgs-unstable";
  };
  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      moviepy = pkgs.python3Packages.buildPythonPackage rec {
        pname = "moviepy";
        version = "bc8d1a831d2d1f61abfdf1779e8df95d523947a5";
        doCheck = false;
        propagatedBuildInputs = with pkgs.python3Packages; [
          numpy
          decorator
          imageio
          imageio-ffmpeg
          tqdm
          requests
          proglog
        ];
        src = (
          pkgs.fetchFromGitHub {
            owner = "Zulko";
            repo = pname;
            rev = version;
            sha256 = "sha256-qgaXEHzUNCrUXbTVqvDlhjkkceK5WdQ+h6gfacEt2H4=";
          }
        )

        ;
      };
      pyopencv4 = pkgs.python311Packages.opencv4.override {
        enableGtk2 = true;
        gtk2 = pkgs.gtk2;
        #enableFfmpeg = true; #here is how to add ffmpeg and other compilation flags
        #ffmpeg_3 = pkgs.ffmpeg;
        };

    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          python3Packages.setuptools # pkg_resources cannot find moudle thingy
          python3Packages.imageio-ffmpeg
          python3Packages.ffmpeg-python
          python3Packages.tqdm
          ffmpeg



          pyopencv4
          #python312Packages.moviepy	
          python3Packages.pytesseract

        ] ++ [ moviepy ];
        shellHook = ''
        '';
      };
      formatter.${system} = pkgs.nixpkgs-fmt;
    };
}

