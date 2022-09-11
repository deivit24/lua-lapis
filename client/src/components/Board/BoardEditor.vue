<template>
  <v-card id="Editor" width="500px" outlined class="mx-auto">
    <v-row no-gutters class="text-left pa-2">
      <v-col cols="12">
        <v-text-field
          v-model="name"
          label="Name"
          placeholder="Anonymous User"
          class="mx-2"
          :disabled="isAuth"
        ></v-text-field>
      </v-col>
      <v-col cols="12" class="pt-0">
        <v-text-field
          v-model="subject"
          label="Subject"
          placeholder="Enter Subject(Optional)"
          class="mx-2 pt-0"
        ></v-text-field>
      </v-col>
      <v-col cols="12" class="pt-0">
        <v-checkbox
          v-model="isLewd"
          label="Does post contain lewd content"
        ></v-checkbox>
      </v-col>
    </v-row>
    <v-row no-gutters v-if="editor" class="text-left pa-2">
      <v-btn
        @click="editor.chain().focus().toggleBold().run()"
        :class="[{ 'is-active': editor.isActive('bold') }, 'tool-btn']"
        icon
        small
      >
        <v-icon>mdi-format-bold</v-icon>
      </v-btn>
      <v-btn
        @click="editor.chain().focus().toggleItalic().run()"
        :class="[{ 'is-active': editor.isActive('italic') }, 'tool-btn']"
        icon
        small
      >
        <v-icon>mdi-format-italic</v-icon>
      </v-btn>
      <v-btn
        @click="editor.chain().focus().toggleStrike().run()"
        :class="[{ 'is-active': editor.isActive('strike') }, 'tool-btn']"
        icon
        small
      >
        <v-icon>mdi-format-strikethrough</v-icon>
      </v-btn>
      <span class="separator">|</span>
      <v-btn
        @click="openLinkDialog"
        :class="[{ 'is-active': editor.isActive('link') }, 'tool-btn']"
        icon
        small
      >
        <v-icon>mdi-link</v-icon>
      </v-btn>
      <v-btn
        @click="openFileSelector"
        :class="[{ 'is-active': editor.isActive('file') }, 'tool-btn']"
        icon
        small
      >
        <v-icon>mdi-paperclip</v-icon>
      </v-btn>
      <span class="separator">|</span>
      <v-btn
        @click="editor.chain().focus().toggleBulletList().run()"
        :class="[{ 'is-active': editor.isActive('bulletList') }, 'tool-btn']"
        icon
        small
      >
        <v-icon>mdi-format-list-bulleted</v-icon>
      </v-btn>
      <v-btn
        @click="editor.chain().focus().toggleOrderedList().run()"
        :class="[{ 'is-active': editor.isActive('orderedList') }, 'tool-btn']"
        icon
        small
      >
        <v-icon>mdi-format-list-numbered</v-icon>
      </v-btn>
      <span class="separator">|</span>
      <v-btn
        @click="editor.chain().focus().toggleCode().run()"
        :class="[{ 'is-active': editor.isActive('code') }, 'tool-btn']"
        icon
        small
      >
        <v-icon>mdi-code-tags</v-icon>
      </v-btn>
      <v-btn
        @click="editor.chain().focus().toggleCodeBlock().run()"
        :class="[{ 'is-active': editor.isActive('codeBlock') }, 'tool-btn']"
        icon
        small
      >
        <v-icon>mdi-code-braces</v-icon>
      </v-btn>
      <v-spacer></v-spacer>
      <v-btn
        @click="editor.chain().focus().undo().run()"
        icon
        small
        class="tool-btn mr-auto"
      >
        <v-icon>mdi-undo</v-icon>
      </v-btn>
      <v-btn
        @click="editor.chain().focus().redo().run()"
        icon
        small
        class="tool-btn"
      >
        <v-icon>mdi-redo</v-icon>
      </v-btn>
    </v-row>
    <editor-content class="text-left" :editor="editor" />
    <span
      v-if="errorMessage"
      class="error--text text-left text-capitalize mb-0 ml-3"
    >
      [{{ errorMessage }}]
    </span>
    <board-link
      :key="linkDialog"
      :dialog="linkDialog"
      :link="link"
      :link-text="linkText"
      @close="linkDialog = false"
      @addLink="setLink"
    />
    <v-file-input
      id="fileUpload"
      v-model="file"
      accept="image/*"
      label="File input"
      prepend-icon=""
      hide-details
      solo
      show-size
      color="default"
      style="width: 200px"
      flat
      :class="display"
      dense
    >
      <template v-slot:selection="{ text }">
        <v-chip small label color="default">
          {{ text }}
        </v-chip>
      </template></v-file-input
    >
    <v-card-actions class="pt-0">
      <v-spacer></v-spacer>
      <v-btn depressed small color="default" @click="submit">Submit Post</v-btn>
    </v-card-actions>
  </v-card>
</template>

<script>
import { Editor, EditorContent } from "@tiptap/vue-2";
import StarterKit from "@tiptap/starter-kit";
import Placeholder from "@tiptap/extension-placeholder";
import Link from "@tiptap/extension-link";
import BoardLink from "./BoardLink";
import { BoardsApi } from "../../services/boards";
import { mapGetters } from "vuex";

export default {
  components: {
    EditorContent,
    BoardLink,
  },
  props: {
    boardId: {
      type: Number,
      require: true,
    },
  },
  data() {
    return {
      editor: null,
      value: "",
      linkDialog: false,
      link: "",
      linkText: "",
      file: null,
      display: "d-none",
      base64: null,
      name: "",
      subject: "",
      errorMessage: "",
      isLewd: false,
    };
  },
  watch: {
    value(value) {
      // HTML
      const isSame = this.editor.getHTML() === value;
      if (isSame) {
        return;
      }
      this.editor.commands.setContent(value, false);
    },
    file(value) {
      if (value) {
        this.display = "";
        this.createBase64Image(value);
        console.log(this.base64);
      } else {
        this.display = "d-none";
        this.base64 = null;
      }
    },
    isAuth(val) {
      if (val) {
        this.name = this.authUser.username;
      } else {
        this.name = "";
      }
    },
  },
  created() {
    this.editor = new Editor({
      content: this.value,
      extensions: [
        StarterKit,
        Link,
        Placeholder.configure({
          placeholder: "Anonymous Message",
        }),
      ],
    });
    if (this.isAuth) {
      this.name = this.authUser.username;
    }
  },
  beforeDestroy() {
    this.editor.destroy();
  },
  computed: {
    ...mapGetters({
      authUser: "auth/user",
      isAuth: "auth/isLoggedIn",
    }),
  },
  methods: {
    createBase64Image: function (FileObject) {
      const reader = new FileReader();
      reader.onload = (event) => {
        this.base64 = event.target.result;
      };
      reader.readAsDataURL(FileObject);
    },
    openLinkDialog() {
      const previousUrl = this.editor.getAttributes("link").href;
      const { view, state } = this.editor;
      const { from, to } = view.state.selection;
      const text = state.doc.textBetween(from, to, "");
      this.linkText = text;
      this.link = previousUrl;
      this.linkDialog = true;
    },
    setLink(url, linkText) {
      // cancelled
      if (url === null) {
        return;
      }
      // empty
      if (url === "") {
        this.editor.chain().focus().extendMarkRange("link").unsetLink().run();

        return;
      }

      // update link
      this.editor
        .chain()
        .focus()
        .extendMarkRange("link")
        .setLink({ href: url })
        .run();
      this.editor.commands.insertContent(linkText);
      this.linkDialog = false;
    },
    openFileSelector() {
      document.getElementById("fileUpload").click();
    },
    async submit() {
      try {
        const data = {
          name: this.name == "" ? "Anonymous User" : this.name,
          file_name: this.file?.name,
          file_size: this.file?.size,
          file_base64: this.base64,
          body: this.editor.getHTML() == "<p></p>" ? "" : this.editor.getHTML(),
          subject: this.subject,
          lewd: this.isLewd,
        };
        if (!this.file) {
          delete data.file_name;
          delete data.file_size;
          delete data.file_base64;
        }

        await BoardsApi.createBoardPost(this.boardId, data);
        this.$emit("newPost");
        this.reset();
      } catch (e) {
        this.errorMessage = e.response.data[0];
        setTimeout(() => {
          this.errorMessage = "";
        }, 5000);
      }
    },
    reset() {
      this.isLewd = false;
      this.file = null;
      this.base64 = null;
      this.value = "";
      this.name = "";
      this.subject = "";
      this.editor.commands.setContent(this.value, false);
    },
  },
};
</script>

<style lang="scss" scoped>
.tool-btn {
  color: grey;
  padding: 5px !important;
  min-width: 0;
  border-radius: 5px;
}
.is-active {
  background: rgba(255, 255, 255, 0.2);
}
#Editor {
  ::v-deep .ProseMirror {
    padding: 5px 15px 10px 15px;

    &:focus {
      outline: none;
    }
    p {
      margin-bottom: 0;
    }
    .is-editor-empty:first-child::before {
      content: attr(data-placeholder);
      float: left;
      color: #616161;
      pointer-events: none;
      height: 0;
    }
  }
  ::v-deep .separator {
    font-family: "Roboto";
    align-self: center;
    display: inline-block;
    transform: scale(1, 1.5);
    color: rgba(255, 255, 255, 0.9);
    margin: 2px 2px;
  }
}
</style>
