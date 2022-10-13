import shutil

utilizedPrograms = []
allProgramsInstalled = True

# Add necessary installs
utilizedPrograms.append("rg")
utilizedPrograms.append("lazygit")
utilizedPrograms.append("tldr")

print("Checking which programs are needed for my config..\n")

for program in utilizedPrograms:
    if not shutil.which(program):
        print("Please Install: {}".format(program))
        allProgramsInstalled = False

if allProgramsInstalled:
    print("All programs are already installed")
else:
    print("Done")
