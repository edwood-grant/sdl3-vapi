using SDL;

namespace Math3D {
    public struct Matrix4x4 {
        float m11; float m12; float m13; float m14;
        float m21; float m22; float m23; float m24;
        float m31; float m32; float m33; float m34;
        float m41; float m42; float m43; float m44;

        public float get (int index0, int index1) {
            if (index0 == 0) {
                switch (index1) {
                case 0:
                    return m11;
                case 1:
                    return m12;
                case 2:
                    return m13;
                case 3:
                    return m14;
                default:
                    assert_not_reached ();
                }
            } else if (index0 == 1) {
                switch (index1) {
                case 0:
                    return m21;
                case 1:
                    return m22;
                case 2:
                    return m23;
                case 3:
                    return m24;
                default:
                    assert_not_reached ();
                }
            } else if (index0 == 2) {
                switch (index1) {
                case 0:
                    return m31;
                case 1:
                    return m32;
                case 2:
                    return m33;
                case 3:
                    return m34;
                default:
                    assert_not_reached ();
                }
            } else if (index0 == 3) {
                switch (index1) {
                case 0:
                    return m41;
                case 1:
                    return m42;
                case 2:
                    return m43;
                case 3:
                    return m44;
                default:
                    assert_not_reached ();
                }
            }
            assert_not_reached ();
        }

        public void set (int index0, int index1, float value) {
            if (index0 == 0) {
                switch (index1) {
                case 0:
                    m11 = value;
                    break;
                case 1:
                    m12 = value;
                    break;
                case 2:
                    m13 = value;
                    break;
                case 3:
                    m14 = value;
                    break;
                }
            } else if (index0 == 1) {
                switch (index1) {
                case 0:
                    m21 = value;
                    break;
                case 1:
                    m22 = value;
                    break;
                case 2:
                    m23 = value;
                    break;
                case 3:
                    m24 = value;
                    break;
                }
            } else if (index0 == 2) {
                switch (index1) {
                case 0:
                    m31 = value;
                    break;
                case 1:
                    m32 = value;
                    break;
                case 2:
                    m33 = value;
                    break;
                case 3:
                    m34 = value;
                    break;
                }
            } else if (index0 == 3) {
                switch (index1) {
                case 0:
                    m41 = value;
                    break;
                case 1:
                    m42 = value;
                    break;
                case 2:
                    m43 = value;
                    break;
                case 3:
                    m44 = value;
                    break;
                }
            }
        }

        public Matrix4x4.perspective (float field_of_view,
                                      float aspect_ratio,
                                      float near_plane_distance,
                                      float far_plane_distance) {
            float num = 1.0f / ((float) StdInc.tanf (field_of_view * 0.5f));

            m11 = num / aspect_ratio;
            m12 = 0;
            m13 = 0;
            m14 = 0;

            m21 = 0;
            m22 = num;
            m23 = 0;
            m24 = 0;

            m31 = 0;
            m32 = 0;
            m33 = far_plane_distance / (near_plane_distance - far_plane_distance);
            m34 = -1;

            m41 = 0;
            m42 = 0;
            m43 = (near_plane_distance * far_plane_distance) / (near_plane_distance - far_plane_distance);
            m44 = 0;
        }

        public Matrix4x4.identity () {
            m11 = 1; m12 = 0; m13 = 0; m14 = 0;
            m21 = 0; m22 = 1; m23 = 0; m24 = 0;
            m31 = 0; m32 = 0; m33 = 1; m34 = 0;
            m41 = 0; m42 = 0; m43 = 0; m44 = 1;
        }

        public Matrix4x4.translation (float x, float y, float z)
        {
            m11 = 1; m12 = 0; m13 = 0; m14 = 0;
            m21 = 0; m22 = 1; m23 = 0; m24 = 0;
            m31 = 0; m32 = 0; m33 = 1; m34 = 0;
            m41 = x; m42 = y; m43 = z; m44 = 1;
        }

        public Matrix4x4.scale (float x, float y, float z)
        {
            m11 = x; m12 = 0; m13 = 0; m14 = 0;
            m21 = 0; m22 = y; m23 = 0; m24 = 0;
            m31 = 0; m32 = 0; m33 = z; m34 = 0;
            m41 = 0; m42 = 0; m43 = 0; m44 = 1;
        }

        public Matrix4x4.rotationX (float angle_deg) {
            float cos = StdInc.cosf (angle_deg * (StdInc.PI_F / 180.0f));
            float sin = StdInc.sinf (angle_deg * (StdInc.PI_F / 180.0f));

            m11 = 1; m12 = 0;   m13 = 0;    m14 = 0;
            m21 = 0; m22 = cos; m23 = -sin; m24 = 0;
            m31 = 0; m32 = sin; m33 = cos;  m34 = 0;
            m41 = 0; m42 = 0;   m43 = 0;    m44 = 1;
        }

        public Matrix4x4.rotationY (float angle_deg) {
            float cos = StdInc.cosf (angle_deg * (StdInc.PI_F / 180.0f));
            float sin = StdInc.sinf (angle_deg * (StdInc.PI_F / 180.0f));

            m11 = cos;  m12 = 0; m13 = sin; m14 = 0;
            m21 = 0;    m22 = 1; m23 = 0;   m24 = 0;
            m31 = -sin; m32 = 0; m33 = cos; m34 = 0;
            m41 = 0;    m42 = 0; m43 = 0;   m44 = 1;
        }

        public Matrix4x4.rotationZ (float angle_deg) {
            float cos = StdInc.cosf (angle_deg * (StdInc.PI_F / 180.0f));
            float sin = StdInc.sinf (angle_deg * (StdInc.PI_F / 180.0f));

            m11 = cos; m12 = -sin; m13 = 0; m14 = 0;
            m21 = sin; m22 = cos;  m23 = 0; m24 = 0;
            m31 = 0;   m32 = 0;    m33 = 1; m34 = 0;
            m41 = 0;   m42 = 0;    m43 = 0; m44 = 1;
        }

        public static Matrix4x4 multiply (Matrix4x4 matrix1, Matrix4x4 matrix2) {
            var result = Matrix4x4 ();
            for (int x = 0; x < 4; x++) {
                for (int y = 0; y < 4; y++) {
                    float sum = 0;
                    for (int i = 0; i < 4; i++) {
                        sum += matrix1[x, i] * matrix2[i, y];
                    }
                    result[x, y] = sum;
                }
            }
            return result;
        }
    }
}