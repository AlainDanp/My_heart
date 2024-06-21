class UnbordingContent {
  String title;
  String description;

  UnbordingContent({
    required this.title,
    required this.description,
  });
}

List<UnbordingContent> contents = [
  UnbordingContent(
    title: 'Prise de tension: Poids',
    description: "La prise de tension artérielle permet de mesurer la pression du sang dans les artères. ",
  ),
  UnbordingContent(
    title: 'Prise de tension : Diastole',
    description: "La pression diastolique correspond à la pression dans les artères lorsque le cœur se "
        "relâche entre deux battements.",
  ),
  UnbordingContent(
    title: 'Prise de tension: Systole',
    description: "La pression systolique est la pression exercée par le sang sur les parois des artères lorsque le cœur "
        "se contracte.",
  ),
  UnbordingContent(
    title: 'Prise de tension: Puls',
    description: "Le pouls est le nombre de battements du cœur par minute. ",
  ),
];
