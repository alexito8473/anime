enum StatusAnime{
  emission(stateCode: 1),
  finalized(stateCode: 2),
  soon(stateCode: 3);
    final int stateCode;
    const StatusAnime({required this.stateCode});
    String urlSearch(){
     return 'status%5B%5D=$stateCode';
    }
}