import 'package:api/config/environment.dart';
import 'package:s3_client/s3_client.dart';

class S3Service {
  final S3Client m_client;
  final S3Client m_publicClient;

  S3Service()
    : m_client = S3Client(
        baseEndpoint: .parse(Environment.S3Endpoint),
        region: Environment.S3Region,
        credentials: .static(
          accessKeyId: Environment.S3AccessKey,
          secretAccessKey: Environment.S3SecretKey,
        ),
        usePathStyle: true,
      ),
      m_publicClient = S3Client(
        baseEndpoint: Uri.parse(Environment.S3PublicEndpoint),
        region: Environment.S3Region,
        credentials: .static(
          accessKeyId: Environment.S3AccessKey,
          secretAccessKey: Environment.S3SecretKey,
        ),
        usePathStyle: true,
      );

  Future<Uri> GenerateUploadUrl({required String key}) async {
    final aux = await this.m_publicClient.presignPutObject(
      bucket: Environment.S3Bucket,
      key: key,
      expires: Duration(hours: 1)
    );

    return aux;
  }

  Future<Uri> GenerateDownloadUrl({required String key}) async {
    final aux = await this.m_publicClient.presignGetObject(
      bucket: Environment.S3Bucket,
      key: key,
      expires: Duration(hours: 1)
    );

    return aux;
  }
}
