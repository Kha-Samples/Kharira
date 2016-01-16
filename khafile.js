var project = new Project('KhajakTest');
project.addLibrary('Khajak');
project.addAssets('Assets/**');
project.addSources('Sources');
project.addShaders('Libraries/Khajak/Sources/khajak/Shaders/**');
return project;
