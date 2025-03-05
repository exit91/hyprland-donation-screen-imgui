#include <GLES2/gl2.h>
#include <GLFW/glfw3.h>
#include <imgui.h>
#include <imgui_impl_glfw.h>
#include <imgui_impl_opengl3.h>
#include <stdio.h>

const char* TITLE = "Support Hyprland 😊 ";

const char* TEXT =
    "Hyprland is maintained by volunteers, and led by one person in their free "
    "time.\n"
    "Your support is valuable, and helps fund  Hyprland's continued "
    "existence.\n\n"
    "You can donate once, or monthly, and it takes less than 5 minutes.";

const char* FONT_PATH =
    "/nix/store/dcz583cyfqn6bz7dny80qlmlkafs1wki-noto-fonts-24.3.1/share/fonts/"
    "noto/NotoSans[wdth,wght].ttf";

const char* FONT_PATH_EMOJI = "./noto-untouchedsvg.ttf";

static void glfw_error_callback(int error, const char* description) {
    fprintf(stderr, "GLFW Error %d: %s\n", error, description);
}

int main(void) {
    GLFWwindow* window = nullptr;
    ImFont* largeFont = nullptr;

    // GLFW initialization
    {
        glfwSetErrorCallback(glfw_error_callback);

        if (!glfwInit()) {
            return 1;
        }

        glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 2);
        glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 0);
        glfwWindowHint(GLFW_CLIENT_API, GLFW_OPENGL_ES_API);
        glfwWindowHint(GLFW_TRANSPARENT_FRAMEBUFFER, GLFW_TRUE);
        glfwWindowHint(GLFW_FLOATING, GLFW_TRUE);
        glfwWindowHint(GLFW_RESIZABLE, GLFW_FALSE);
        if (glfwPlatformSupported(GLFW_PLATFORM_WAYLAND)) {
            glfwInitHint(GLFW_PLATFORM, GLFW_PLATFORM_WAYLAND);
        } else {
            fprintf(stderr, "no wayland support detected");
        }

        window = glfwCreateWindow(600, 235, TITLE, nullptr, nullptr);

        if (window == nullptr) {
            glfwTerminate();
            return 1;
        }

        glfwMakeContextCurrent(window);
        glfwSwapInterval(1);
    }

    // ImGUI initialization
    {
        IMGUI_CHECKVERSION();
        ImGui::CreateContext();
        ImGuiIO* io = &ImGui::GetIO();
        io->ConfigFlags |= ImGuiConfigFlags_NavEnableKeyboard;
        io->ConfigFlags |= ImGuiConfigFlags_NavEnableGamepad;

        io->Fonts->AddFontFromFileTTF(FONT_PATH, 20.0f);
        largeFont = io->Fonts->AddFontFromFileTTF(FONT_PATH, 24.0f);

        ImGui_ImplGlfw_InitForOpenGL(window, true);
        ImGui_ImplOpenGL3_Init("#version 100");
    }

    // Styling
    {
        ImGui::StyleColorsDark();
        ImGuiStyle& style = ImGui::GetStyle();
        style.FrameRounding = 4.0f;
        style.FramePadding = ImVec2(16.0f, 12.0f);
        style.Colors[ImGuiCol_Text] = ImVec4(0.22f, 0.74f, 0.97f, 1.0f);
        style.Colors[ImGuiCol_Button] = ImVec4(0.11f, 0.37f, 0.53f, 0.5f);
        style.Colors[ImGuiCol_ButtonHovered] =
            ImVec4(0.11f, 0.37f, 0.53f, 0.7f);
        style.Colors[ImGuiCol_ButtonActive] = ImVec4(0.11f, 0.37f, 0.53f, 0.9f);
    }

    // main loop
    while (!glfwWindowShouldClose(window)) {
        glfwPollEvents();

        ImGui_ImplOpenGL3_NewFrame();
        ImGui_ImplGlfw_NewFrame();
        ImGui::NewFrame();

        // Set window size
        {
            ImGuiViewport* viewport = ImGui::GetMainViewport();
            ImGui::SetNextWindowPos(viewport->Pos);
            ImGui::SetNextWindowSize(viewport->Size);
        }

        // define ui
        {
            ImGui::Begin("Donatepls", nullptr,
                         ImGuiWindowFlags_NoDecoration |
                             ImGuiWindowFlags_NoResize);

            if (ImGui::IsKeyPressed(ImGuiKey_Escape) ||
                ImGui::IsKeyPressed(ImGuiKey_GamepadFaceRight)) {
                fprintf(stdout, "Canceled\n");
                glfwSetWindowShouldClose(window, GLFW_TRUE);
            }

            {
                ImGui::PushFont(largeFont);
                ImGui::Text("%s", TITLE);
                ImGui::Text("\n");
                ImGui::PopFont();
            }
            ImGui::Separator();
            {
                ImGui::Text("\n");
                ImGui::TextWrapped("%s", TEXT);
                ImGui::Text("\n\n");
            }

            if (ImGui::Button("Donate")) {
                fprintf(stdout, "Pressed donate\n");
                glfwSetWindowShouldClose(window, GLFW_TRUE);
            }
            ImGui::SameLine();
            if (ImGui::Button("No thanks")) {
                fprintf(stdout, "Pressed No thanks\n");
                glfwSetWindowShouldClose(window, GLFW_TRUE);
            }

            ImGui::End();
        }

        // render
        {
            ImGui::Render();
            ImGui_ImplOpenGL3_RenderDrawData(ImGui::GetDrawData());
            glfwSwapBuffers(window);
        }
    }

    // cleanup
    {
        ImGui_ImplOpenGL3_Shutdown();
        ImGui_ImplGlfw_Shutdown();
        ImGui::DestroyContext();

        glfwDestroyWindow(window);
        glfwTerminate();
    }

    return 0;
}
