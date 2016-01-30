var project = new Project('KhajakTest');
project.addLibrary('Khajak');
project.addLibrary('haxebullet');
project.addAssets('Assets/**');
project.addSources('Sources');
project.addShaders('Libraries/Khajak/Sources/khajak/Shaders/**');
project.addShaders('Sources/Shaders/**');
return project;
