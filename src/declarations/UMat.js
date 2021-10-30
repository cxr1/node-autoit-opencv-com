module.exports = [
    ["class cv.UMat", "", ["/Simple", "/DC"], [
        ["int", "rows", "", ["/R"]],
        ["int", "cols", "", ["/R"]],
        ["int", "dims", "", ["/R"]],
        ["size_t", "step", "", ["/R"]],
        ["int", "width", "", ["/R", "=cols"]],
        ["int", "height", "", ["/R", "=rows"]]
    ], "", ""],

    ["cv.UMat.UMat", "", [], [
        ["UMat", "m", "", []]
    ], "", ""],

    ["cv.UMat.UMat", "", [], [
        ["UMatUsageFlags", "usageFlags", "cv::USAGE_DEFAULT", []]
    ], "", ""],

    ["cv.UMat.UMat", "", [], [
        ["int", "rows", "", []],
        ["int", "cols", "", []],
        ["int", "type", "", []],
        ["UMatUsageFlags", "usageFlags", "cv::USAGE_DEFAULT", []]
    ], "", ""],

    ["cv.UMat.UMat", "", [], [
        ["int", "rows", "", []],
        ["int", "cols", "", []],
        ["int", "type", "", []],
        ["Scalar", "s", "", []],
        ["UMatUsageFlags", "usageFlags", "cv::USAGE_DEFAULT", []]
    ], "", ""],

    ["cv.UMat.getMat", "Mat", [], [
        ["int", "access", "", ["/Cast=static_cast<cv::AccessFlag>"]]
    ], "", ""],
];
