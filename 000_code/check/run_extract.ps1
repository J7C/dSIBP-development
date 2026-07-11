$mathExe = "D:\Wolfram Research\Wolfram\15.0\math.exe"
$script = "D:\Agent-projects-nut\dSibp_package\000_code\check\000_extract_ref.wl"
$stdout = "D:\Agent-projects-nut\dSibp_package\000_code\check\extract_ref_stdout.txt"

Start-Process $mathExe -ArgumentList "-noprompt","-script","`"$script`"" -RedirectStandardOutput $stdout -Wait -NoNewWindow
