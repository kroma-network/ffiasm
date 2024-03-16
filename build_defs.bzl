load("@aspect_rules_js//js:defs.bzl", "js_run_binary")

def generate_prime_field(
        name,
        modulus,
        asm_out = None,
        h_out = None,
        c_out = None,
        element_h_out = None,
        generic_c_out = None,
        raw_generic_c_out = None,
        arm64_s_out = None):
    args = [
        "-q={}".format(modulus),
        "-n={}".format(name),
    ]

    repository_name = native.repository_name()
    if repository_name == "@":
        chdir = native.package_name()
    else:
        chdir = "/".join(["external", repository_name[1:], native.package_name()])

    if asm_out != None:
        args.append("--oa={}".format(asm_out))
    else:
        asm_out = name + ".asm"

    if h_out != None:
        args.append("--oh={}".format(h_out))
    else:
        h_out = name + ".hpp"

    if c_out != None:
        args.append("--oc={}".format(c_out))
    else:
        c_out = name + ".cpp"

    if element_h_out != None:
        args.append("--oelemh={}".format(element_h_out))
    else:
        element_h_out = name + "_element.hpp"

    if generic_c_out != None:
        args.append("--ogenc={}".format(generic_c_out))
    else:
        generic_c_out = name + "_generic.cpp"

    if raw_generic_c_out != None:
        args.append("--orawgenc={}".format(raw_generic_c_out))
    else:
        raw_generic_c_out = name + "_raw_generic.cpp"

    if arm64_s_out != None:
        args.append("--oarm64s={}".format(arm64_s_out))
    else:
        arm64_s_out = name + "_raw_arm64.s"

    js_run_binary(
        name = name,
        outs = [
            asm_out,
            h_out,
            c_out,
            element_h_out,
            generic_c_out,
            raw_generic_c_out,
            arm64_s_out,
        ],
        args = args,
        chdir = chdir,
        tool = "@iden3_ffiasm//:buildzqfield",
    )
