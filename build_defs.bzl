load("@aspect_rules_js//js:defs.bzl", "js_run_binary")

def generate_asm(
        name,
        modulus,
        out = None):
    args = [
        "-q={}".format(modulus),
        "-n={}".format(name),
    ]

    repository_name = native.repository_name()
    if repository_name == "@":
        chdir = native.package_name()
    else:
        chdir = "/".join(["external", repository_name[1:], native.package_name()])

    if out != None:
        args.append("--oa={}".format(out))
    else:
        out = name + ".asm"

    js_run_binary(
        name = name,
        outs = [out],
        args = args,
        chdir = chdir,
        tool = "@iden3_ffiasm//:buildzqfield",
    )
