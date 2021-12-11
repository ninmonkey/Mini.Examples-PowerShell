
 NOTE: Cacls is now deprecated, please use Icacls.

 Displays or modifies access control lists (ACLs) of files

 CACLS filename [/T] [/M] [/L] [/S[:SDDL]] [/E] [/C] [/G user:perm]
        [/R user [...]] [/P user:perm [...]] [/D user [...]]
    filename      Displays ACLs.
    /T            Changes ACLs of specified files in
                  the current directory and all subdirectories.
    /L            Work on the Symbolic Link itself versus the target
    /M            Changes ACLs of volumes mounted to a directory
    /S            Displays the SDDL string for the DACL.
    /S:SDDL       Replaces the ACLs with those specified in the SDDL string
                  (not valid with /E, /G, /R, /P, or /D).
    /E            Edit ACL instead of replacing it.
    /C            Continue on access denied errors.
    /G user:perm  Grant specified user access rights.
                  Perm can be: R  Read
                               W  Write
                               C  Change (write)
                               F  Full control
    /R user       Revoke specified user's access rights (only valid with /E).
    /P user:perm  Replace specified user's access rights.
                  Perm can be: N  None
                               R  Read
                               W  Write
                               C  Change (write)
                               F  Full control
    /D user       Deny specified user access.
 Wildcards can be used to specify more than one file in a command.
 You can specify more than one user in a command.

 Abbreviations:
    CI - Container Inherit.
         The ACE will be inherited by directories.
    OI - Object Inherit.
         The ACE will be inherited by files.
    IO - Inherit Only.
         The ACE does not apply to the current file/directory.
    ID - Inherited.
         The ACE was inherited from the parent directory's ACL.
