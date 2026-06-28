{
  nm.default =
  let
    constants = {
      stateVersion = "26.05";
    };
  in
  {
    _module.args = { inherit constants; };
  };
}
