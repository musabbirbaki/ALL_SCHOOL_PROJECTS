/* The header file for BezierPath class. This class contains the variables used by the Bezier Path
 * functions (currently in main). The BezierPath's purpose is to create multiple bezier curves given
 * multiple points. If three points, P1, P2 and P3 are given, then Bezier Path will calculate 3 Bezier
 * curves, P1 -> P2, P2 -> P3, and P3 -> P1 and give the vertices of all the points that these curves
 * consist of. If an object travels along these points, then it will be like they are following a path
 * from point to point.                                                                                     */

#include <glm/glm.hpp>

class BezierPath {
    private:
        glm::vec3 C1;
        glm::vec3 C2;
        glm::vec3 C3;
        glm::vec3 C4; 

        int numJumps;
        int numSegments;
        float jumpHeight;

        float curveType;

    public: 
        BezierPath(int numJumps, int numSegments, float jumpHeight, float curveType) {
            this->numJumps = numJumps;
            this->numSegments = numSegments;
            this->jumpHeight = jumpHeight;
            this->curveType = curveType;
        }

        // Getters
        glm::vec3 getC1() {return C1;};
        glm::vec3 getC2() {return C2;};
        glm::vec3 getC3() {return C3;};
        glm::vec3 getC4() {return C4;};

        int getNumJumps() {return numJumps;};
        int getNumSegments() {return numSegments;};
        float getJumpHeight() {return jumpHeight;};
        float getCurveType() {return curveType;}

        // Setters
        void setC1(glm::vec3 C1) {this->C1 = C1;};
        void setC2(glm::vec3 C2) {this->C2 = C2;};
        void setC3(glm::vec3 C3) {this->C3 = C3;};
        void setC4(glm::vec3 C4) {this->C4 = C4;};

        void setNumJumps(int numJumps) {this->numJumps = numJumps;};
        void setNumSegments(int numSegments) {this->numSegments = numSegments;};
        void setJumpHeight(float jumpHeight) {this->jumpHeight = jumpHeight;};
        void setCurveType(float curveType) {this->curveType = curveType;};
};
