<template>
  <v-card outlined id="Editor">
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
        @click="openFileSelector"
        :class="[{ 'is-active': editor.isActive('file') }, 'tool-btn']"
        icon
        small
      >
        <v-icon>mdi-paperclip</v-icon>
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
    </v-row>
    <editor-content class="text-left" :editor="editor" />
    <v-file-input
      id="commentFileUpload"
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
    <v-card-actions class="justify-end pt-2">
      <v-btn x-small text class="mr-2" color="error" @click="reset">
        [ DISCARD COMMENT ]
      </v-btn>
      <v-btn x-small outlined color="primary" @click="submitComment">
        [ SUBMIT COMMENT ]
      </v-btn>
    </v-card-actions>
  </v-card>
</template>

<script>
import { Editor, EditorContent } from "@tiptap/vue-2";
import StarterKit from "@tiptap/starter-kit";
import Placeholder from "@tiptap/extension-placeholder";
export default {
  name: "BoardCommentEditor",
  components: {
    EditorContent,
  },
  data: () => ({
    editor: null,
    file: null,
    display: "d-none",
    base64: null,
  }),
  watch: {
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
  },
  created() {
    this.editor = new Editor({
      autoFocus: true,
      extensions: [
        StarterKit,
        Placeholder.configure({
          placeholder: "Start writing a comment",
        }),
      ],
    });
  },
  beforeDestroy() {
    this.editor.destroy();
  },
  methods: {
    createBase64Image: function (FileObject) {
      const reader = new FileReader();
      reader.onload = (event) => {
        this.base64 = event.target.result;
      };
      reader.readAsDataURL(FileObject);
    },
    reset() {
      this.$emit("close");
      this.editor.commands.setContent("<p></p>");
    },
    submitComment() {
      const value = this.editor.getHTML();
      const data = {
        body: value,
      };
      console.log(data);
      if (value === "<p></p>") return;
      this.$emit("submit", value);
    },
    openFileSelector() {
      document.getElementById("commentFileUpload").click();
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
