rclone ls "rarsa69:album/IDs" | sed 's/^ \+-1 //g' > photos.txt
rclone copy "rarsa69:album/IDs/"(shuf -n 1 photos.txt) .

#qdbus-qt5 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript '
#                           var allDesktops = desktops();
#                           print (allDesktops);
#                           for (i=0;i<allDesktops.length;i++) {{
#                               d = allDesktops[i];
#                               d.wallpaperPlugin = "org.kde.image";
#                               d.currentConfigGroup = Array("Wallpaper",
#                                                            "org.kde.image",
#                                                            "General");
#                               d.writeConfig("Image", "file:///home/papa/IMG_20140417_233444.jpg")
#                           }}
#                       '



