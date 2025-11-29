enum JamaicanParishes {
  westmoreland('Westmoreland', 'westmoreland'),
  hanover('Hanover', 'hanover'),
  stJames('St. James', 'st.james'),
  stElizabeth('St. Elizabeth', 'st.elizabeth'),
  trelawny('Trelawny', 'trelawny'),
  manchester('Manchester', 'manchester'),
  stAnn('St. Ann', 'st.ann'),
  clarendon('Clarendon', 'clarendon'),
  stCatherine('St. Catherine', 'st.catherine'),
  stAndrew('St. Andrew', 'st.andrew'),
  stMary('St. Mary', 'st.mary'),
  kingston('Kingston', 'kingston'),
  portland('Portland', 'portland'),
  stThomas('St. Thomas', 'st.thomas');

  const JamaicanParishes(this.title, this.queryParam);
  final String title;
  final String queryParam;
}

extension JamaicanParishExtension on JamaicanParishes {

  static JamaicanParishes fromApi(String parish) {
    switch (parish) {
      case "westmoreland":
        return JamaicanParishes.westmoreland;
      case "hanover":
        return JamaicanParishes.hanover;
      case "st.james":
        return JamaicanParishes.stJames;
      case "st.elizabeth":
        return JamaicanParishes.stElizabeth;
      case "trelawny":
        return JamaicanParishes.trelawny;
      case "manchester":
        return JamaicanParishes.manchester;
      case "st.ann":
        return JamaicanParishes.stAnn;
      case "clarendon":
        return JamaicanParishes.clarendon;
      case "st.catherine":
        return JamaicanParishes.stCatherine;
      case "st.andrew":
        return JamaicanParishes.stAndrew;
      case "st.mary":
        return JamaicanParishes.stMary;
      case "kingston":
        return JamaicanParishes.kingston;
      case "portland":
        return JamaicanParishes.portland;
      case "st.thomas":
        return JamaicanParishes.stThomas;
      default:
        throw Exception('Unknown Parish: $parish');
    }
  }
}
