enum StatusAnime{
  EMISSION(stateCode: 1),
  FINALIZED(stateCode: 2),
  PROXIMAMANTE(stateCode: 3);
    final int stateCode;
    const StatusAnime({required this.stateCode});
    String urlSearch(){
     return "status%5B%5D=$stateCode";
    }
}