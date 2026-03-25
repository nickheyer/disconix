{ self, inputs, ... }:
{

  perSystem =
    { pkgs, ... }:
    {

      packages.discoNoctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
        settings = { };
      };
    };
}
