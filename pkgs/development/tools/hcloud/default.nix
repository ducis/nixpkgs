{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hcloud";
  version = "1.16.1";

  goPackagePath = "github.com/hetznercloud/cli";

  src = fetchFromGitHub {
    owner = "hetznercloud";
    repo = "cli";
    rev = "v${version}";
    sha256 = "1d6qa21sq79hr84nnn3j7w0776mnq58g8g1krpnh4d6bv3kc3lq7";
  };

  modSha256 = "1zy41hi2qzrdmih3pkpng8im576lhkr64zm66w73p7jyvy0kf9sx";

  buildFlagsArray = [ "-ldflags=" "-w -X github.com/hetznercloud/cli/cli.Version=${version}" ];

  postInstall = ''
    mkdir -p \
      $out/etc/bash_completion.d \
      $out/share/zsh/vendor-completions

    # Add bash completions
    $out/bin/hcloud completion bash > "$out/etc/bash_completion.d/hcloud"

    # Add zsh completions
    echo "#compdef hcloud" > "$out/share/zsh/vendor-completions/_hcloud"
    $out/bin/hcloud completion zsh >> "$out/share/zsh/vendor-completions/_hcloud"
  '';

  meta = {
    description = "A command-line interface for Hetzner Cloud, a provider for cloud virtual private servers";
    homepage = "https://github.com/hetznercloud/cli";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.zauberpony ];
  };
}
