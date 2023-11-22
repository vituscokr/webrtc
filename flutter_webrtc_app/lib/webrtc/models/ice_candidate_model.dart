class IceCandidateModel {
  String? candidate;
  String? sdpMid;
  int? sdpMLineIndex;
  String? to;

  IceCandidateModel({this.candidate, this.sdpMid, this.sdpMLineIndex, this.to});

  factory IceCandidateModel.fromJson(Map json) {
    return IceCandidateModel(
      candidate: json['candidate'],
      sdpMid: json['sdpMid'],
      sdpMLineIndex: json['sdpMlineIndex'],
      to: json['to'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'candidate': candidate,
      'sdpMid': sdpMid,
      'sdpMlineIndex': sdpMLineIndex,
      'to': to,
    };
  }
}
