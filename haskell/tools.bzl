"""Tools used during build."""

def get_build_tools(ctx):
  """Get the set of all build tools we have available.

  Args:
    ctx: Rule context.

  Returns:
    depset of File: All build tools provided to the rule.
  """
  return depset([
    t for t in ctx.toolchains["@io_tweag_rules_haskell//haskell:toolchain"].tools
  ])

def get_build_tools_path(ctx):
  """Get list of build tools suited for PATH.

  Useful to make sure that GHC can find e.g. hsc2hs at runtime: even
  if those files aren't expected, user may just be using OPTIONS_GHC
  to invoke them so they should be available.

  Args:
    ctx: Rule context.

  Returns:
    string: colon-separated paths to all build tools.
  """
  return ":".join(depset([bt.dirname for bt in get_build_tools(ctx).to_list()]).to_list())

def _get_build_tool(ctx, tool_name):
  """Find the requested build tool from all the build tools we were given.

  Args:
    ctx: Rule context.
    tool_name: Name of the binary we want to find.

  Returns:
    File: Build tool with the name user asked for.
  """
  for tool in get_build_tools(ctx).to_list():
    if tool.basename == tool_name:
      return tool

  fail("Could not find the '{0}' tool.".format(tool_name))

def get_compiler(ctx):
  """Get the compiler path.

  Args:
    ctx: Rule context.

  Returns:
    File: Compiler to use.
  """
  return _get_build_tool(ctx, "ghc")

def get_compiler_version(ctx):
  """Get the compiler version.

  Args:
    ctx: Rule context.

  Returns:
    String: Version string.
  """
  return ctx.toolchains["@io_tweag_rules_haskell//haskell:toolchain"].version

def get_ghc_pkg(ctx):
  """Get the compiler path.

  Args:
    ctx: Rule context.

  Returns:
    File: ghc-pkg to use.
  """
  return _get_build_tool(ctx, "ghc-pkg")

def get_hsc2hs(ctx):
  """Get the hsc2hs tool.

  Args:
    ctx: Rule context.

  Returns:
    File: hsc2hs to use.
  """
  return _get_build_tool(ctx, "hsc2hs")


def get_haddock(ctx):
  """Get the haddock tool.

  Args:
    ctx: Rule context.

  Returns:
    File: haddock to use.
  """
  return _get_build_tool(ctx, "haddock")
